import pandas as pd
import numpy as np
import re
from sklearn.metrics.pairwise import cosine_similarity

# --- 1. การโหลดและการทำความสะอาดข้อมูล (Data Cleaning) ---

# โหลดไฟล์ข้อมูล
file_path = "/content/Symptom.csv"
df = pd.read_csv(file_path)

# Symptom List
df["symptom_list"] = df["search_term"].apply(
    lambda x: [s.strip() for s in str(x).split(",") if s.strip() != ""]
)

# กรองแถวที่ไม่มีอาการและสร้าง Session_ID ใหม่
df = df[df['symptom_list'].apply(len) > 0].reset_index(drop=True)
df['Session_ID'] = df.index


# --- 2. การสร้าง Item-Item Matrix (Symptom-Session Matrix) ---

# ขยายรายการอาการเพื่อให้แต่ละอาการอยู่ในแถวเดียว
df_exploded = df.explode('symptom_list')
df_exploded = df_exploded.rename(columns={'symptom_list': 'Symptom'})

# สร้างตารางปฏิสัมพันธ์ระหว่าง Session และ Symptom (User-Item Matrix)
# โดยกำหนดให้ค่าเป็น 1 ถ้าอาการนั้นถูกเลือกในเซสชันนั้น
session_symptom_matrix = pd.crosstab(df_exploded['Session_ID'], df_exploded['Symptom'])

# Transpose matrix เพื่อให้ได้ Symptom-Session Matrix (Item-Item Matrix)
symptom_item_matrix = session_symptom_matrix.T


# --- 3. การคำนวณความคล้ายคลึง (Item Similarity) ---

# คำนวณความคล้ายคลึงกันของอาการโดยใช้ Cosine Similarity
similarity_matrix = cosine_similarity(symptom_item_matrix)

# สร้าง DataFrame สำหรับตารางความคล้ายคลึง
similarity_df = pd.DataFrame(
    similarity_matrix, 
    index=symptom_item_matrix.index, 
    columns=symptom_item_matrix.index
)


# --- 4. ฟังก์ชันการแนะนำ (Recommendation Function) ---

def recommend_symptoms(selected_symptoms, similarity_df, top_n=5):
    """
    ฟังก์ชันแนะนำอาการถัดไปโดยใช้ Item-Item Collaborative Filtering
    
    Parameters:
    - selected_symptoms (list): รายการอาการที่ผู้ใช้กำลังเลือก
    - similarity_df (DataFrame): ตารางความคล้ายคลึงของอาการ
    - top_n (int): จำนวนอาการที่ต้องการแนะนำ
    
    Returns:
    - list: รายการอาการที่แนะนำ
    """
    
    # 1. กรองอาการที่ป้อนเข้ามาว่ามีอยู่ในโมเดลหรือไม่
    valid_selected_symptoms = [symptom for symptom in selected_symptoms if symptom in similarity_df.index]
    
    if not valid_selected_symptoms:
        print("💡 Error: อาการที่เลือกไม่พบในฐานข้อมูล")
        return []

    # 2. คำนวณคะแนนสะสมสำหรับอาการที่สามารถแนะนำได้
    candidate_scores = {}
    
    for selected_symptom in valid_selected_symptoms:
        # ดึงค่าความคล้ายคลึงของอาการที่เลือกกับอาการอื่น ๆ ทั้งหมด
        similarities = similarity_df[selected_symptom]
        
        for symptom, score in similarities.items():
            # ข้ามอาการที่ผู้ใช้เลือกไปแล้ว
            if symptom in selected_symptoms:
                continue
            
            # สะสมคะแนน: ยิ่งอาการคล้ายกันมาก คะแนนยิ่งสูง
            candidate_scores[symptom] = candidate_scores.get(symptom, 0) + score

    # 3. จัดเรียงและส่งคืนผลลัพธ์
    recommended_symptoms_with_score = sorted(
        candidate_scores.items(), 
        key=lambda item: item[1], 
        reverse=True
    )
    
    # ดึงเฉพาะชื่ออาการ Top N
    return [symptom for symptom, score in recommended_symptoms_with_score[:top_n]]


# --- 5. ตัวอย่างการใช้งาน (Example Usage) ---

# 1. หาอาการยอดนิยมที่สุด 2 อันดับแรกเพื่อใช้เป็นตัวอย่าง
most_popular_symptoms = symptom_item_matrix.sum(axis=1).sort_values(ascending=False).head(2).index.tolist()
example_input_1 = most_popular_symptoms

# 2. ตัวอย่างการทำงาน
recommendations_1 = recommend_symptoms(example_input_1, similarity_df, top_n=5)

print("--- ผลลัพธ์การสร้างระบบแนะนำอาการ (Item-Item CF) ---")
print(f"จำนวนเซสชันที่ใช้ในการเทรน: {len(df)}")
print(f"จำนวนอาการที่ไม่ซ้ำกันทั้งหมด: {len(symptom_item_matrix.index)}\n")

print(f"**ตัวอย่างที่ 1: อาการที่เลือกคือ {example_input_1}**")
print(f"อาการที่แนะนำ (Top 5): {recommendations_1}\n")

# 3. ตัวอย่างที่สอง (ลองป้อนอาการที่เกี่ยวข้องกับระบบอื่น เช่น อาการภูมิแพ้/ผิวหนัง)
example_input_2 = ['ผื่น', 'คัน']
recommendations_2 = recommend_symptoms(example_input_2, similarity_df, top_n=5)

print(f"**ตัวอย่างที่ 2: อาการที่เลือกคือ {example_input_2}**")
print(f"อาการที่แนะนำ (Top 5): {recommendations_2}")
