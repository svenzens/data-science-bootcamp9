# Game : Hammer Scissor Paper
import random

def greeting_name():
    username = input("what's your name: ")
    message = f"Hi {username}, welcome to the game!"
    print(message)

def p1_input():
    p1 = input("Choose your items (hammer(h), scissor(s), paper(p)): ")
    return p1

def com_input():
    com = random.choice(['h', 's', 'p'])
    return com

def check_result(p1, com):
    if p1 == com:
      return "It's draw"
    elif (
      (p1 == 'p' and com == 'h') or
      (p1 == 's' and com == 'p') or
      (p1 == 'h' and com == 's')
    ):
      return "Yes"
    else:
      return "No"

def play_game():
    greeting_name()
    print("Let's play the game 🔥")
    score_p1 = 0
    score_com = 0
    round = 1
    while True:
      p1 = p1_input()
      com = com_input()
      print(f"Game Round: {round}")
      print(f"P1 choose: {p1}")
      print(f"Com choose: {com}")
      score_text = check_result(p1, com)
      print(score_text)
      if "Yes" in score_text:
        score_p1 += 1
      elif "No" in score_text:
        score_com += 1
      print(f"{score_p1} : {score_com}")
      status = input("Do you want to continue or stop?")
      if status == "stop": # end game
        print("Game Over!")
        if score_p1 > score_com:
            print("You Win! 💖")
        elif score_p1 < score_com:
            print("You Lose! 💔")
        else:
            print("Draw! 🤝")
        print("Thank you for join the game !!")
        break
      else:
        print("Let's continue.")
        round += 1
play_game()
