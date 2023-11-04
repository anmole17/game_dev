#mr tic tac toe
mrttt <- c("       XXXXXXXXXXXXXXXXXXXXXX",
           "    XXXXXXXXXXXXXXXXXXXXXXXXXXXXX", 
           "  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
           " XXXXXXXXXXXXXXXXXX         XXXXXXXX", 
           "XXXXXXXXXXXXXXXX              XXXXXXX",
           "XXXXXXXXXXXXX                   XXXXX", 
           " XXX     _________ _________     XXX      ",
           "  XX    I  _xxxxx I xxxxx_  I    XX        ", 
           " ( X----I         I         I----X )           ",
           "( +I    I      00 I 00      I    I+ )", 
           " ( I    I    __0  I  0__    I    I )      /\\    /\\    |\"\"\")  -------  -------  -------", 
           "  (I    I______ /   \\_______I    I)      /  \\  /  \\   |___)     |   __   |   __   |", 
           "   I           ( ___ )           I      /    \\/    \\  |   \\ *   |        |        |", 
           "   I    _  :::::::::::::::  _    I           ",
           "    \\    \\___ ::::::::: ___/    /          ", 
           "     \\_      \\_________/      _/",
           "       \\        \\___/        /", 
           "         \\                 /",
           "          |\\             /|", 
           "          |  \\_________/  |")

# values of board and function to print the board
b_val <- c(1,2,3,4,5,6,7,8,9)

board <- function(){
  cat("\n       |       |\n")
  cat(paste("  ",b_val[1], "  |  ",b_val[2],"  |  ",b_val[3]))
  cat('\n_______|_______|_____')
  cat("\n       |       |\n")
  cat(paste("  ",b_val[4], "  |  ",b_val[5],"  |  ",b_val[6]))
  cat('\n_______|_______|_____')
  cat("\n       |       |\n")
  cat(paste("  ",b_val[7], "  |  ",b_val[8],"  |  ",b_val[9]))
  cat("\n       |       |\n")
}

#function to input the values from user
input_value <- function(string){
  if (interactive()) {
    con <- stdin()
  } else {
    con <- "stdin"
  }
  cat(string)
  symbol <- readLines(con = con,n = 1)
  return(symbol)
}

# make the menu input name and X/O choice give the other choice to cpu
menus <- function(){
  cat(mrttt, sep = "\n")
  cat("WELCOME PLAYER! I am Mr. Tic Tac Toe \nShall we play a game? \n")
  playername <- input_value("What is your name challenger?\n")
  while (T) {
    xno <- input_value(c(playername,", Select your mark: X or O \n"))
    xno <- toupper(xno)
    if (xno != "X" & xno != "O") {
      cat("\nWrong input! Try Again!\n")
      next
    }else if (xno == "X") {
      human <- "X"
      cpu <- "O"
      break
    }else if (xno == "O") {
      human <- "O"
      cpu <- "X"
      break
    }
    
  }
  return(list(playername = playername, human = human, cpu = cpu))
}
menu_val <- menus()
playername <- menu_val$playername
human <- menu_val$human
cpu <- menu_val$cpu
board()

# function to input human move and mark it on the board
marking <- function(){
  while (T) {
    move = input_value(c("\nEnter your move",playername,
                         ", type the number where you want to mark(1-9). \n"))
    move <- tryCatch(as.numeric(move),
                     error = function(e){
                       FALSE
                     },
                     warning = function(w){
                       FALSE
                     })
    
    if (!move | is.na(move)) { # when input move is invalid or empty
      cat("\nWrong Input!! Try Again \n")
    }else if (is.numeric(move)) {
      if (move >= 1 & move < 10) {
        if (b_val[move] != 'X' & b_val[move] != 'O') {
          b_val[move] <<- human
          break
        }else{
          cat("\nPosition already taken, try different position!\n")
        }
      }else{
        cat("\nWrong Input!! Enter a number from 1-9 \n")
      }
    }
  }
  board()
}

# to check after and before every move if anyone wins
# adds 1 to x for continous symbols in winning_vectors,
# Example: X|X|X will add 3, i.e. win; X|X|O add 2, no win; X|O|X will add 1, 
# and after reading O move to next vector  
checkwin <- function(){
  winning_vector <- list(c(1,2,3),c(4,5,6),c(7,8,9),c(1,4,7),
                         c(2,5,8),c(3,6,9),c(1,5,9),c(7,5,3))
  symbol_vec <- c(human, cpu)
  win <- FALSE
  winner <- ''
  for (win_seq in winning_vector) {
    for (play in symbol_vec) {
      win_sum <- 0
      for (block in win_seq) {
        if (b_val[block] == play) {
          win_sum <- win_sum + 1
        } else next
      }
      if (win_sum == 3) { 
        win <- T
        winner <- play
        return(c(win, winner))
      }else next
    }
  } 
  return(c(win, winner))
}

# function cpucheck() for cpu to read the board, compare values, 
# magic_board represents a board with numbers which add up to 15 [8,3,4,1,5,9,6,7,2] represents 
# [1,2,3,4,5,6,7,8,9] positions in vertical, horizontal or diagonals,
#
#   8    |   3  |  4  +=15
# ________________________
#   1   |   5  |  9  += 15
# ________________________
#   6  |   7  |  2  +=15
#  _______________________
# +=15| +=15 |+=15

# Similarly it adds up to 15 for diagonals
# checks if human or cpu can win in the next move, i.e.
# if hum = 2, there are 2 continuous symbols, win possible in next move
# returns the positions to play for cpu in such condition, i.e.
# 15 - sum of magic board sum, example if sum is 13, the next move needs 2 more,
# so according to magic board with reference to board is 9th position.
cpucheck <- function(player){
  check <- rbind(c(1,2,3),c(4,5,6),c(7,8,9),c(1,4,7),
                 c(2,5,8),c(3,6,9),c(1,5,9),c(7,5,3))
  magic_board <- rbind(c(8,3,4),c(1,5,9),c(6,7,2),c(8,1,6),
                       c(3,5,7),c(4,9,2),c(8,5,2),c(6,5,4))
  mgk_scr <- 0
  if (player == 'X')
  {
    enemy <- 'O'
  } else enemy <- 'X'
  
  for (x in 1:8) { # each vector 
    win_sum <- 0
    mgk_brd_sum <- 0
    for (y in 1:3) { # each symbol
      if (b_val[check[x,y]] == player) {
        win_sum <- win_sum + 1
        mgk_brd_sum <- magic_board[x,y] + mgk_brd_sum
        # if the continuous marks is broken by enemy mark set win sum to 0
      }else if (b_val[check[x,y]] == enemy) { 
        win_sum <- 0
        break
      }else next
    }
    # if next move may end up as win or loose
    if (win_sum == 2) { 
      mgk_scr <- 15 - mgk_brd_sum
      return(c(win_sum,mgk_scr))
    }else next
  }
  return(c(0,0))
}

#function for cpu to mark it's fav position
cpumarking <- function(term,fav1,fav2) {
  cat("\nMy move\n")
  indexs <- c(8,3,4,1,5,9,6,7,2)
  hum_scr <- cpucheck(human)
  cpu_scr <- cpucheck(cpu)
  
  # priority check if win or loose is possible in next move
  if (cpu_scr[1] == 2) {
    index <- which(indexs == cpu_scr[2])[[1]]
    if (b_val[index] != human & b_val[index] != cpu) {
      b_val[index] <<- cpu
      board()
      return(c(fav1,fav2)) 
    }
  }else if (hum_scr[1] == 2) {
    index <- which(indexs == hum_scr[2])[[1]]
    if (b_val[index] !=  human & b_val[index] !=  cpu) {
      b_val[index] <<- cpu
      board()
      return(c(fav1,fav2))
    }
  }
  # even term for X ,odd for O
  if (term == 1 | term == 8) {
    fav1 <- cpu1_8()
  }else if (term == 2) {
    fav1 <- cpu2() 
  }else if (term == 3) {
    fav <- cpu3(fav1)
    fav1 <- fav[1]
    fav2 <- fav[2]
  }else if (term == 4 | term == 6) {
    fav <- cpu4_6(fav1)
    fav1 <- fav[1]
    fav2 <- fav[2]
  }else if (term == 5) {
    fav1 <- cpu5(fav1) 
  }else if (term == 7) {
    fav <- cpu7(fav1,fav2)
    fav1 <- fav[1]
    fav2 <- fav[2]
  }else {
    fav <- cpu_random()
    fav1 <- fav[1]
    fav2 <- fav[2]
    cat()
    
  }
  board()
  return(c(fav1,fav2))
}

# functions which mark for respective term accordingly
# the odd numbers are for 'X' and even numbers are for 'O' 
# as more moves are placed, 
cpu1_8 <- function() {
  arr <- c(1,3,7,9)
  for (fav_pos in 1:4) {
    if (b_val[arr[fav_pos]] != human & b_val[arr[fav_pos]] !=  cpu) {
      b_val[arr[fav_pos]] <<- cpu
      return(fav_pos)     
    }else next
  }
# return 1 if fav position was already taken
  random <- cpu_random()
  return(random[1])
}

# position 5(center) is fav in 2nd move, this is for 'O'
cpu2 <- function(){ 
  if (b_val[5] != human & b_val[5] !=  cpu) {
    b_val[5] <<- cpu
    return(1)
  }else {
    fav1 <- cpu1_8() 
    return(fav1)
  }
}

# input the fav. vector and choose between the 2 best pos.
cpu3 <- function(fav1){ 
  arr <- rbind(c(7,3),c(9,1),c(1,9),c(7,3))
  for (fav2 in 1:2) {
    if (b_val[arr[fav1,fav2]] != human & b_val[arr[fav1,fav2]] != cpu) {
      b_val[arr[fav1,fav2]] <<- cpu
      return(c(fav1,fav2))
    }else next
  }
# if fav. positions are already filled return a random pos.
  random <- cpu_random() 
  return(random)
}

# if the cpu has the centre vs if it doesn't returns different fav. positions.
cpu4_6 <- function(fav1){
  arr <- rbind(c(8,6),c(4,8),c(2,6),c(4,2))
  if (b_val[5] == cpu) { 
    for (fav3 in 1:4) {
      for (fav2 in 1:2) {
        if (b_val[arr[fav3,fav2]] != human & b_val[arr[fav3,fav2]] != cpu) {
          b_val[arr[fav3,fav2]] <<- cpu
          return(c(fav3,fav2)) 
        }else next
      }
    }
  }else{
    for (fav2 in 1:2) { 
      if (b_val[arr[fav1,fav2]] != human & b_val[arr[fav1,fav2]] != cpu) {
        b_val[arr[fav1,fav2]] <<- cpu
        return(c(fav1,fav2))
      }else next
    }
  }
  random <- cpu_random()
  return(random)
}

cpu5 <- function(fav1){
  arr <- c(9,7,3,1)
  if (b_val[arr[fav1]] != human & b_val[arr[fav1]] != cpu) {
    b_val[arr[fav1]] <<- cpu
    return(fav1)
  }else {
    random <- cpu_random()
    return(random[1])
  }
}

cpu7 <- function(fav1,fav2){
  arr <- rbind(c(4,2),c(6,2),c(4,8),c(8,6))
  if (b_val[5] != human & b_val[5] != cpu) {
    b_val[5] <<- cpu
    return(c(fav1,fav2))
  }else if (b_val[arr[fav1,fav2]] != human & b_val[arr[fav1,fav2]] != cpu) {
    b_val[arr[fav1,fav2]] <<- cpu
    return(c(fav1,fav2))
  }else {
    random <- cpu_random()
    return(random)
  }
}

# a function to mark randomly if the conditions are not fav for cpu
cpu_random <- function(){
  arr <- sample(1:9, 9, replace = FALSE)
  for (fav in arr) {
    if (b_val[fav] != human & b_val[fav] != cpu) {
      b_val[fav] <<- cpu
      return(c(1,1))
    }else next
  }
}

win_loose <- function(win)
{
  if (win[1]) {
    cat(paste(win[2], " won!!\n"))
  }
  if (win[2] == human) {
    cat(paste("This time you won" ,playername ,", you won't be lucky next time."))
  }else if (win[2] == cpu) {
    cat(paste("Good game, well played" ,playername ,",but you can't beat me in your lifetime!"))
  }else if (win[1] == FALSE) {
    cat("It is a draw. You were a worthy challenger! Next time I will win.", playername)
  }
}
# to play the game, mark by marking() and cpumarking() and check for winner at start of each loop
# global var to be used in the functions
fav1i <- 1
fav2i <- 1
play <- function(turn)
{ win <- checkwin()
  if (win[1]) {
    return(0)
  }else if (human == 'X' & turn %% 2 != 0) {
    marking()
  }else if (human == 'O' & turn %% 2 == 0) {
    marking()
  }else{
    mark <- cpumarking(turn,fav1i,fav2i)
    fav1i <<- mark[1]
    fav2i <<- mark[2]
  }
  
  return(c(fav1i, fav2i))
}

play_var <- sapply(1:9, play)
win <- checkwin()
win_loose(win)
