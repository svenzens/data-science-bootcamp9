game <- function() {

# Start
print("Hello, welcome to the game! 🎮")
username <- readline("What's your name ? :")
print(paste("Let's play the game, 🔥", username))

# Rule
items <- c("hammer", "scissor", "paper")

# Score
score_p1 <- 0
score_com <- 0

flush.console()

while (TRUE) {

p1 <- readline(paste("Choose your items (hammer, scissor, paper): "))
bot <- sample(items, 1)

if (p1 == "quit") {
    print("Game Over!!")
    break
    }

# Check winner
  if (p1 == bot) {
      print(paste("Try Again!", p1, "draws", bot))
      } else if (
      (p1 == "hammer" & bot == "scissor") |
      (p1 == "scissor" & bot == "paper") |
      (p1 == "paper" & bot == "hammer")
      ) {
      print(paste("Yes!", p1, "beats", bot))
      score_p1 = score_p1 + 1
      print(paste(score_p1, ":", score_com))
      } else {
      print(paste("Oh no!", bot, "beats", p1))
      score_com = score_com + 1
      print(paste(score_p1, ":", score_com))
      }

  flush.console()
}

# Check point
if (score_p1 > score_com) {
    print("You win!, 🥂")
    } else if (score_p1 < score_com) {
    print("You Lose! 😿")
    } else {
    print("Draw! 🤝")
    }
    print("thank you for join the game !!")

}
