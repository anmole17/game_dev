#!/usr/bin/python3
import random

# mr tic tac toe
mrttt = '''
       XXXXXXXXXXXXXXXXXXXXXX
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXX         XXXXXXXX
XXXXXXXXXXXXXXXX              XXXXXXX
XXXXXXXXXXXXX                   XXXXX
 XXX     _________ _________     XXX      
  XX    I  _xxxxx I xxxxx_  I    XX        
 ( X----I         I         I----X )           
( +I    I      00 I 00      I    I+ )
 ( I    I    __0  I  0__    I    I )      /\    /\    |""")  -------  -------  -------
  (I    I______ /   \_______I    I)      /  \  /  \   |___)     |   __   |   __   |
   I           ( ___ )           I      /    \/    \  |   \ *   |        |        |
   I    _  :::::::::::::::  _    I           
    \    \___ ::::::::: ___/    /          
     \_      \_________/      _/
       \        \___/        /
         \                 /
          |\             /|
          |  \_________/  |
 \n'''
# values of board and print the board
bval = [0, 1, 2, 3, 4, 5, 6, 7, 8]


def board():
    print("\n")
    print("     |     |")
    print("  {}  |  {}  |  {}".format(bval[0], bval[1], bval[2]))
    print("_____|_____|_____")
    print("     |     |")
    print("  {}  |  {}  |  {}".format(bval[3], bval[4], bval[5]))
    print("_____|_____|_____")
    print("     |     |")
    print("  {}  |  {}  |  {}".format(bval[6], bval[7], bval[8]))
    print("     |     |")
    print("\n")


# make the menu input name and X/O choice give the other choice to cpu
def menu():
    i = 0
    print(mrttt)
    print("WELCOME PLAYER!!! I am Mr. Tic Tac Toe \nShall we play some TIC TAC TOE? \n")
    playername = input("What is your name challenger ?\n")
    while i == 0:
        try:
            xno = int(
                input(
                    "{},Select your mark: X or O \nFor X Press 1 \nFor O Press 0 \n".format(
                        playername
                    )
                )
            )
        except ValueError:
            print("\nWrong Input!!! Try Again \n")
            continue
        if xno == 1 or xno == 0:
            i = 1
            if xno == 1:
                human = "X"
                cpu = "O"
            else:
                human = "O"
                cpu = "X"
        else:
            print("\n Wrong input! Try Again! \n")
    return playername, human, cpu


playername, human, cpu = menu()
bval = [0, 1, 2, 3, 4, 5, 6, 7, 8]
board()

# function to input human move and place it
def marking():

    j = 0
    while j == 0:
        try:
            move = int(
                input(
                    "\nEnter your move {}, type the number where you want to mark. \n".format(
                        playername
                    )
                )
            )
        except ValueError:
            print("\nWrong Input!!! Try Again \n")
            continue
        if move >= 0 and move < 9:
            if bval[move] != "X" and bval[move] != "O":
                bval[move] = human
                j = 1
            else:
                print("Position already taken, try different position!")
        else:
            print("\nWrong Input!!! Try Again \n")
    board()


# to check after and before every move if anyone wins
def checkwin():
    wld = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [6, 4, 2],
    ]
    hc = [human, cpu]
    win = False
    winner = ""
    for seq in wld:
        for play in hc:
            x = 0
            for block in seq:
                if bval[block] == play:
                    x = x + 1
                else:
                    continue
            if x == 3:
                win = True
                winner = play
                return win, winner
            else:
                continue
    return win, winner


# for cpu to read the board, compare values, ck represents a board with numbers which add up to 15 [8,3,4,1,5,9,6,7,2] represents [0,1,2,3,4,5,6,7,8] positions in vertical, horizontal or diognals,
# checks if human or cpu can win in the next move, returns the positions to play for cpu in such condition.
# there are 2 functions for this because of a bug.
def cpucheckh():
    check = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [6, 4, 2],
    ]
    ck = [
        [8, 3, 4],
        [1, 5, 9],
        [6, 7, 2],
        [8, 1, 6],
        [3, 5, 7],
        [4, 9, 2],
        [8, 5, 2],
        [6, 5, 4],
    ]
    hs = 0
    for x in range(8):
        h = 0
        kh = 0
        for y in range(3):
            if bval[check[x][y]] == human:
                h = h + 1
                kh = ck[x][y] + kh
            elif bval[check[x][y]] == cpu:
                h = 0
                break
            else:
                continue
        if h == 2:
            hs = 15 - kh
            return h, hs
        else:
            continue
    return 0, 0


def cpucheckc():
    check = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [6, 4, 2],
    ]
    ck = [
        [8, 3, 4],
        [1, 5, 9],
        [6, 7, 2],
        [8, 1, 6],
        [3, 5, 7],
        [4, 9, 2],
        [8, 5, 2],
        [6, 5, 4],
    ]
    cs = 0
    for x in range(8):
        c = 0
        kc = 0
        for y in range(3):
            if bval[check[x][y]] == cpu:
                c = c + 1
                kc = ck[x][y] + kc
            elif bval[check[x][y]] == human:
                c = 0
                break
            else:
                continue
        if c == 2:
            cs = 15 - kc
            return c, cs
        else:
            continue
    return c, cs


# function for cpu to mark it's fav position
def cpumarking(term, a, b):
    print("\nMy move\n")
    indexs = [8, 3, 4, 1, 5, 9, 6, 7, 2]
    h, hs = cpucheckh()
    c, cs = cpucheckc()
    if c == 2:
        index = indexs.index(cs)
        if bval[index] != human and bval[index] != cpu:
            bval[index] = cpu
            board()
            return a, b
    elif h == 2:
        index = indexs.index(hs)
        if bval[index] != human and bval[index] != cpu:
            bval[index] = cpu
            board()
            return a, b

    # even term for X ,odd for O
    if term == 0 or term == 7:
        a = cpu07()
    elif term == 1:
        a = cpu1()
    elif term == 2:
        a, b = cpu2(a)
    elif term == 3 or term == 5:
        a, b = cpu35(a)
    elif term == 4:
        a = cpu4(a)
    elif term == 6:
        a, b = cpu6(a, b)
    else:
        a = cpurand()
    board()
    return a, b


# functions which mark for respective term accordingly
def cpu07():
    arr = [0, 2, 6, 8]
    for a in range(4):
        if bval[arr[a]] != human and bval[arr[a]] != cpu:
            bval[arr[a]] = cpu
            return a
        else:
            continue
    a, b = cpurand()
    return a


def cpu1():
    if bval[4] != human and bval[4] != cpu:
        bval[4] = cpu
        return 0
    else:
        a = cpu07()
        return a


def cpu2(a):
    arr = [[6, 2], [8, 0], [0, 8], [6, 2]]
    for b in range(2):
        if bval[arr[a][b]] != human and bval[arr[a][b]] != cpu:
            bval[arr[a][b]] = cpu
            return a, b
        else:
            continue
    a, b = cpurand()
    return a, b


def cpu35(a):
    arr = [[7, 5], [3, 7], [1, 5], [3, 1]]
    if bval[4] == cpu:
        for c in range(4):
            for b in range(2):
                if bval[arr[c][b]] != human and bval[arr[c][b]] != cpu:
                    bval[arr[c][b]] = cpu
                    return c, b
                else:
                    continue
    else:
        for b in range(2):
            if bval[arr[a][b]] != human and bval[arr[a][b]] != cpu:
                bval[arr[a][b]] = cpu
                return a, b
            else:
                continue
    a, b = cpurand()
    return a, b


def cpu4(a):
    arr = [8, 6, 2, 0]
    if bval[arr[a]] != human and bval[arr[a]] != cpu:
        bval[arr[a]] = cpu
        return a
    else:
        a, b = cpurand()
        return a


def cpu6(a, b):
    arr = [[3, 1], [5, 1], [3, 7], [7, 5]]
    if bval[4] != human and bval[4] != cpu:
        bval[4] = cpu
        return a, b
    elif bval[arr[a][b]] != human and bval[arr[a][b]] != cpu:
        bval[arr[a][b]] = cpu
        return a, b
    else:
        a, b = cpurand()
        return a, b


# a function to mark randomly if the conditions are not fav for cpu
def cpurand():
    rand = 0
    while rand == 0:
        arr = random.randint(0, 8)
        if bval[arr] != human and bval[arr] != cpu:
            bval[arr] = cpu
            return 0, 0
        else:
            continue


# loop to play the game, marking() and cpumarking(), check for winner at start of each loop
ai = 0
bi = 0
for i in range(9):
    win, winner = checkwin()
    if win:
        break
    elif human == "X" and i % 2 == 0:
        marking()
    elif human == "O" and i % 2 != 0:
        marking()
    else:
        ai, bi = cpumarking(i, ai, bi)
win, winner = checkwin()
if win:
    print("{} won!!\n".format(winner))
    if winner == human:
        board()
        print("This time you won {}, you won't be lucky next time.".format(playername))
    else:
        board()
        print("Know your place human, I am a superior being.")
# for the draw
if win == False and i == 8:
    print("It is a draw. You were a worthy challenger {}".format(playername))
