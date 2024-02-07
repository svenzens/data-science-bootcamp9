pizza <- function() {

  # Menu
  ids = 1:4
  menus = c("Happening XO", "Cheese Cocktail", "Alaska Crab", "Black Pink")
  prices = c(250, 500, 750, 1000)
  menu_list <- list(id = ids,
                    menu = menus,
                    price = prices)
  df <- data.frame(menu_list)

  # bill
  item <- character()
  qty <- integer()
  cal <- numeric()
  bill <- data.frame(item = item,
                     qty = qty,
                     cal = cal)
  total <- 0

  # Greeting
  print("Welcome to Happening Pizza")
  print("Our Menu")
  print(df)

  # Order
  while (TRUE) {
    print("Which No. do you want ?")
    flush.console()

    order_no <- as.numeric(readline("I want to order No. :"))
    qty <- as.numeric(readline("Total :"))
    print("Order press 1, Bill press 2 ?")
    flush.console()

    item <- df[order_no, 2]
    rate <- df[order_no, 3]
    cal <- qty * rate

    order <- data.frame(item = item,
                       qty = qty,
                       cal = cal)
    bill <- rbind(bill,order)

    total <- total + cal

    more <- readline("Select ( 1 or 2 ) :")
    if ( more == "2")
      break
  }

  # Bill
  print("Bill :")
  print(bill)
  print(paste("Total :", sum(total)))

  flush.console()

  username <- readline("What's your name ? :")
  print(paste("Thank You K.", username))
  print(paste("Your Pizza will be delivered in 30 minutes"))
  print(paste("Enjoy your day with Happening Pizza 🍕"))

}
