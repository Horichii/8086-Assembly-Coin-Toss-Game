; This program simulates a coin toss game with a final score and high score display.
; The game has two modes: Normal and Hardcore.
; The user first chooses the game mode, then decides if to play or no.
; In hardcore mode, the user loses the moment he guesses wrong.
; In normal mode, the user can choose to continue the game till the user decides to stop.
; The final score includes the number of wins and losses.
; An overall result (winner, loser, or tie) is also displayed, based on the number of games played.
; The high score is tracked and displayed upon all games played (before quitting the game).


.MODEL SMALL

.STACK 100H

.DATA

    ; Define box components 
    boxTop DB '***********************************************', '$'
    boxBottom DB '***********************************************', '$'
    
    
    ;Display for game title    
    msgTitleTop DB '      +-----------------+$'
    msgTitle1 DB '      |                 |  $'
    msgTitle2 DB '      |    Coin Toss    |  $'
    msgTitle3 DB '      |                 |  $'
    msgTitleBottom DB '      +-----------------+$'
    
    
    ; Circular display for Heads and Tails
    headsLine1 DB '    *******    $'
    headsLine2 DB '  **       **  $'
    headsLine3 DB '**   HEADS   **$'
    headsLine4 DB '  **       **  $'
    headsLine5 DB '    *******    $'

    
    tailsLine1 DB '    *******    $'
    tailsLine2 DB '  **       **  $'
    tailsLine3 DB '**   TAILS   **$'
    tailsLine4 DB '  **       **  $'
    tailsLine5 DB '    *******    $'

    

    ; Messages   
    msgMenu DB 'Press "p" to play, "o" to exit: $'
    msgGuess DB 'Enter your guess (h for heads, t for tails): $'
    msgTossing DB 'Tossing $'
    msgWin DB 'You win!$'
    msgLose DB 'You lose!$'
    msgPlayAgain DB ' Do you want to play again? (y for yes, n for no): $'
    msgNoPlay DB 'Come play again next time! $'
    msgInvalidInput DB 'Invalid input. Please enter "h" for heads or "t" for tails.', '$'
    msgModeMenu DB 'Choose mode: n for Normal, h for Hardcore: $'
    msgHardcoreMode DB 'Current Mode: Hardcore$'
    msgNormalMode DB 'Current Mode: Normal$'
   
    msgResult DB 'The result is: $'
    
    msgScore DB 'Final Score - Wins: $'
    msgLosses DB ' Losses: $'
    msgFinalWin DB 'You are a winner!$'
    msgFinalLose DB 'You lose!$'
    msgFinalEqual DB 'Tie game!$'
    msgHighScore DB 'High Score: $'
    msgHighScoreHardcore DB 'Hardcore High Score: $'
    msgNewHighScore DB 'New High Score! Wins: $'
    msgNewHighScoreHardcore DB 'New Hardcore mode high score! Wins: $'


    spacing DB ' $'
    newline DB 0DH, 0AH, '$'
    dot DB '.'
    clear_space DB "                         ", "$"
    

    ; Variables   
    playerPlayed DB 0
    userGuess DB ?
    tossResult DB ?
    userPlayAgain DB ?
    playerWins DB 0
    playerWinsHardcore DB 0
    playerLosses DB 0 
    highScore DB 0      ; High score variable to store the highest wins
    highScoreHardcore DB 0
    selectedMode DB ?  ; Variable to store the chosen mode


.CODE

MAIN PROC

    MOV AX, @data
    MOV DS, AX

selectMode:
    
    ;print select mode menu message
    MOV AH, 09H
    LEA DX, msgModeMenu
    INT 21H

    ;get user input (normal or hardcore)
    MOV AH, 01H
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    
    ; Check if Normal mode
    MOV selectedMode, AL
    CMP AL, 'n'      
    JE gameLoop

    ; Check if Hardcore mode
    CMP AL, 'h'      
    JE gameLoop
    
    ; Reprompt if invalid input
    JMP selectMode   

; Main game loop
gameLoop:
    
    ; Display title and menu
    CALL displayMenu
    
    ;Print press 'p' or 'o'
    MOV AH, 09H
    LEA DX, msgMenu
    INT 21H
    
    ; Get user input
    MOV AH, 01H
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    ; Process input
    CMP AL, 'p'
    JE playGame
    CMP AL, 'o'
    JE exit_short
    JMP gameLoop 


;short jump to bypass JE instruction limit
exit_short:
    
    CALL calculateFinalResult
    MOV highScore, 0
    MOV highScoreHardcore, 0
    JMP exitGame
    
    
; game process label
playGame:
    
    ;flag that user has played at least 1 game
    MOV playerPlayed, 1
    
    ; Get user's guess
    CALL getUserGuess

    ; Simulate coin toss
    CALL tossCoin

    ; Display result and determine win/lose
    CALL displayResult
    
    
getUserGuess:
    
    ;Print Guess msg
    MOV AH, 09H
    LEA DX, msgGuess
    INT 21H
    
    
    ;Get user guess input
    
    MOV AH, 01H
    INT 21H
    
    ; Check if the input is 'h' or 't'
    CMP AL, 'h'
    JE valid_input
    
    CMP AL, 't'
    JE valid_input
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    ; Invalid input, handle it (e.g., display an error message and reprompt)
    MOV AH, 09h
    LEA DX, msgInvalidInput
    INT 21h
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    JMP getUserGuess
    

valid_input:
    ; Input is valid, proceed with the game
    MOV userGuess, AL
    
    RET


tossCoin:
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    
    ; Tossing animation
    
    MOV AH, 09H
    LEA DX, msgTossing
    INT 21H
    MOV AH, 02H
    MOV DL, dot
    INT 21H
    CALL delay
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    
    ;2nd Tossing iteration
    
    MOV AH, 09H
    LEA DX, msgTossing
    INT 21H
    MOV AH, 02H
    MOV DL, dot
    INT 21H
    MOV AH, 02H
    MOV DL, dot
    INT 21H
    CALL delay
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    
    ;3rd tossing iteration
    
    MOV AH, 09H
    LEA DX, msgTossing
    INT 21H
    MOV AH, 02H
    MOV DL, dot
    INT 21H
    MOV AH, 02H
    MOV DL, dot
    INT 21H
    MOV AH, 02H
    MOV DL, dot
    INT 21H
    CALL delay
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    
    ; Generate random number (0 or 1)
    MOV AH, 2CH         ;Generate system time. Store at registers ch, cl, dh, dl
    INT 21H
    AND DL, 01H
    MOV tossResult, DL
    RET

    
displayResult:
    
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgResult
    INT 21H
    
    
    ;decision making
    CMP tossResult, 0
    JE displayHeads     
    JMP displayTails

    
displayHeads:
    
    ;first display 
    mov ax, 03h
    int 10h
          
    MOV AH, 09H
    LEA DX, headsLine1
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, headsLine2
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, headsLine3
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, headsLine4
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, headsLine5
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    int 21h
    
    
    CALL delay
      
    ;second display
    mov ax, 03h
    int 10h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 00h
    mov dl, 18h
    int 10h
         
    MOV AH, 09H
    LEA DX, headsLine1
    INT 21H
    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0118h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine2
    INT 21H
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 02h
    mov dl, 18h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine3
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0318h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine4
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0418h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine5
    INT 21H
    
    CALL delay
    
    ;third display
    mov ax, 03h
    int 10h
    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0035h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine1
    INT 21H

    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0135h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine2
    INT 21H
    

    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0235h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine3
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0335h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine4
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0435h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine5
    INT 21H

    CALL delay
    
    ;fourth
    mov ax, 03h
    int 10h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 00h
    mov dl, 18h
    int 10h
         
    MOV AH, 09H
    LEA DX, headsLine1
    INT 21H
    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0118h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine2
    INT 21H
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 02h
    mov dl, 18h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine3
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0318h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine4
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0418h
    int 10h
    
    MOV AH, 09H
    LEA DX, headsLine5
    INT 21H
    
    CALL delay
    
    ;fifth
    mov ax, 03h
    int 10h
          
    MOV AH, 09H
    LEA DX, headsLine1
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, headsLine2
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, headsLine3
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, headsLine4
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, headsLine5
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    int 21h
    
    
    CALL delay
    ; Clear headsLine5 (overwrite with spaces)
    ;MOV AH, 09H
    ;LEA DX, clearspaces   ; Define a line of spaces
    ;INT 21H
    
    
    CMP userGuess, 'h'
    JE win_short
    JMP lose

win_short:
  JMP win  
    
displayTails:
    
        
        ;first display 
    mov ax, 03h
    int 10h
          
    MOV AH, 09H
    LEA DX, tailsLine1
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine2
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine3
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine4
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine5
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    int 21h
    
    
    CALL delay
      
    ;second display
    mov ax, 03h
    int 10h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 00h
    mov dl, 18h
    int 10h
         
    MOV AH, 09H
    LEA DX, tailsLine1
    INT 21H
    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0118h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine2
    INT 21H
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 02h
    mov dl, 18h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine3
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0318h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine4
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0418h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine5
    INT 21H
    
    CALL delay
    
    ;third display
    mov ax, 03h
    int 10h
    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0035h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine1
    INT 21H

    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0135h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine2
    INT 21H
    

    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0235h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine3
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0335h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine4
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0435h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine5
    INT 21H

    CALL delay
    
    ;fourth
    mov ax, 03h
    int 10h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 00h
    mov dl, 18h
    int 10h
         
    MOV AH, 09H
    LEA DX, tailsLine1
    INT 21H
    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0118h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine2
    INT 21H
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 02h
    mov dl, 18h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine3
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0318h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine4
    INT 21H
    
        mov ah, 02h
    mov bh, 00h
    mov dx, 0418h
    int 10h
    
    MOV AH, 09H
    LEA DX, tailsLine5
    INT 21H
    
    CALL delay
    
    ;fifth
    mov ax, 03h
    int 10h
          
    MOV AH, 09H
    LEA DX, tailsLine1
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine2
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine3
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine4
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine5
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    int 21h
    
    
    CALL delay
    
    CMP userGuess, 't'
    JE win
    JMP lose
    
    
win:
    
    ;increment everytime the player wins
    INC playerWins  
    INC playerWinsHardcore
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    ;Print win msg
    MOV AH, 09H
    LEA DX, msgWin
    INT 21H
    
    JMP playAgain

    
lose:
    
    ;increment for every lose
    INC playerLosses
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    ;Print lose msg
    MOV AH, 09H
    LEA DX, msgLose
    INT 21H
    
    ; Check for Hardcore Mode
    CMP selectedMode, 'h'
    
    ;bypass je instruction jump limit
    JE exitGameFinal_short   ; Exit immediately in Hardcore mode
    
    JMP playAgain

exitGameFinal_short:
    CALL displayScore
    CALL calculateFinalResult
    JMP selectMode

playAgain:
    
    ;print playagain display
    MOV AH, 09H
    LEA DX, msgPlayAgain
    INT 21H
    
    ;Take user guess
    MOV AH, 01H
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    ;Store AL value to userPlayAgain var
    MOV userPlayAgain, AL
    
    CMP userPlayAgain, 'y'
    JE playGame_short
    CMP userPlayAgain, 'n'
    JE jumpGame_short
    
    JMP playAgain
    

;label to bypass short instruction jump limit
playGame_short:
    
    JMP playGame

    
;label to bypass short instruction jump limit
jumpGame_short:
    
    CALL displayScore
    CALL calculateFinalResult
    JMP selectMode
    
    
displayScore:
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgScore
    INT 21H
    
    ;Add ASCII value 0 to convert num val to ASCII val
    MOV AL, playerWins
    ADD AL, '0' 
    
    MOV AH, 02H
    MOV DL, AL
    INT 21H

    MOV AH, 09H
    LEA DX, msgLosses
    INT 21H

    ;Add ASCII value 0 to convert num val to ASCII val
    MOV AL, playerLosses
    ADD AL, '0' 
    
    MOV AH, 02H
    MOV DL, AL
    INT 21H

    MOV AH, 09H
    LEA DX, newline
    INT 21H

    CMP selectedMode, 'h'
    JE displayHighScoreHardcore_short
    CALL displayHighScore
    RET
    
    
displayHighScoreHardcore_short:
    JMP displayHighScoreHardcore
    
    
displayHighScore:
    
    CMP selectedMode, 'h'
    JE displayHighScoreHardcore
    ; Check if a new high score is achieved
    MOV AL, playerWins
    
    CMP AL, highScore
    
    JLE displayHighScoreOnly ; If current score is less than or equal to high score, display only high score

    ; Update high score if a new high score is achieved
    MOV highScore, AL
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgNewHighScore
    INT 21H
    
    MOV AL, highScore
    ADD AL, '0'
    MOV AH, 02H
    MOV DL, AL
    INT 21H
    
    JMP endHighScore
    
displayHighScoreHardcore:
    
    MOV AL, playerWinsHardcore
    CMP AL, highScoreHardcore
    JLE displayHighScoreHardcoreOnly
    
    MOV highScoreHardcore, AL
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgNewHighScoreHardcore
    INT 21H
    
    MOV AL, highScoreHardcore
    ADD AL, '0'
    MOV AH, 02H
    MOV DL, AL
    INT 21H
    
    JMP endHighScore
    
displayHighScoreHardcoreOnly:
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgHighScoreHardcore
    INT 21H
    
    MOV AL, highScoreHardcore
    ADD AL, '0'
    MOV AH, 02H
    MOV DL, AL
    INT 21H
    
    JMP endHighScore
    
displayHighScoreOnly:
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgHighScore
    INT 21H
    
    MOV AL, highScore
    ADD AL, '0'
    MOV AH, 02H
    MOV DL, AL
    INT 21H

    
endHighScore:
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    RET
        
    
calculateFinalResult:
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    MOV AL, playerWins
    CMP AL, playerLosses
    
    JE overallEqual_check
    
    JA overallWin      
    
    JB overallLose       

    
overallEqual_check:
    
    CMP AL, 0
    JE didNotPlay
    JMP overallEqual

    
overallWin:
    
    MOV AH, 09H
    LEA DX, msgFinalWin
    INT 21H
    JMP endFinalResult

    
overallLose:
    
    MOV AH, 09H
    LEA DX, msgFinalLose
    INT 21H
    JMP endFinalResult

    
overallEqual:
    
    MOV AH, 09H
    LEA DX, msgFinalEqual
    INT 21H
    JMP endFinalResult

    
didNotPlay:
    
    MOV AH, 09H
    LEA DX, msgNoPlay
    INT 21H
    JMP exitGameFinal

    
endFinalResult:
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    MOV playerWins, 0
    MOV playerWinsHardcore, 0
    MOV playerLosses, 0
    
    RET

    
displayMenu:
    
    MOV AH, 09H
    LEA DX, boxTop
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, boxTop
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgTitleTop
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgTitle1
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgTitle2
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgTitle3
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, msgTitleBottom
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    CALL displayHeadsAndTails

    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, boxBottom
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, boxBottom
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    
    CMP selectedMode, 'n'
    JE showNormalMode

    CMP selectedMode, 'h'
    JE showHardcoreMode
    JMP displayMenuEnd

showNormalMode:
    MOV AH, 09H
    LEA DX, msgNormalMode ;Current Mode: Normal
    INT 21H
    JMP displayMenuEnd

showHardcoreMode:
    MOV AH, 09H
    LEA DX, msgHardcoreMode ;Current Mode: Hardcore
    INT 21H

displayMenuEnd:
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    RET

    
displayHeadsAndTails:
    
    MOV AH, 09H
    LEA DX, headsLine1
    INT 21H
    
    MOV AH, 09H
    LEA DX, spacing
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine1
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    MOV AH, 09H
    LEA DX, headsLine2
    INT 21H
    
    MOV AH, 09H
    LEA DX, spacing
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine2
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    MOV AH, 09H
    LEA DX, headsLine3
    INT 21H
    
    MOV AH, 09H
    LEA DX, spacing
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine3
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    MOV AH, 09H
    LEA DX, headsLine4
    INT 21H
    
    MOV AH, 09H
    LEA DX, spacing
    INT 21H
    
    MOV AH, 09H
    LEA DX, tailsLine4
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    MOV AH, 09H
    LEA DX, headsLine5
    INT 21H
    
    MOV AH, 09H
    LEA DX, spacing
    INT 21H

    MOV AH, 09H
    LEA DX, tailsLine5
    INT 21H
    
    MOV AH, 09H
    LEA DX, newline
    INT 21H
    
    RET

    
    
calculateFinalResult_short:
    
    CALL calculateFinalResult
    
    JMP exitGameFinal

    
exitGame:
    
    CMP playerPlayed, 1
    
    JE calculateFinalResult_short
    
    JMP didNotPlay

    
exitGameFinal:
    MOV AH, 4CH
    INT 21H

; Delay procedure for tossing animation.
delay:

    MOV CX, 500   

   ; Outer loop count (adjust for overall delay duration)
outer_loop:
   
   MOV DX, 60        ; Inner loop count (fine-tunes the delay)
    
    
inner_loop:
    
   MOV BX, 10       ; Nested loop count
    
    
nested_loop:
    
    NOP   ; No operation (burns CPU cycles)
    
    ; Decrement nested counter
    DEC BX      
    
    ; Continue nested loop if BX is not zero
    JNZ nested_loop     
    
    ; Decrease inner loop counter
    DEC DX        

    ; Continue inner loop if DX is not zero
    JNZ inner_loop       
    
    ; Decrease outer loop counter
    DEC CX              
    
    ; Continue outer loop if CX is not zero
    JNZ outer_loop      
    
    RET

    
MAIN ENDP

END MAIN
