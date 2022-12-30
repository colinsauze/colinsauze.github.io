REM Rremote control car code, (C) Copyright Colin Sauze 2006^M
DECLARE SUB keyboard ()
DECLARE SUB program ()
DECLARE SUB setDELAY ()
DECLARE SUB turnleft ()
DECLARE SUB turnright ()
DECLARE SUB goback ()
DECLARE SUB goforward ()

COMMON SHARED delaytime
COMMON SHARED lastdir

CALL setDELAY

call keyboard


SUB goback
OUT &H378, 2

FOR i = 0 TO delaytime
NEXT i

OUT &H378, 0

lastdir = 2

END SUB

SUB goforward
OUT &H378, 1

 
FOR i = 0 TO delaytime
NEXT i

OUT &H378, 0

lastdir = 1
END SUB

SUB keyboard
CLS

'set initial screen position to be centred
y = 12
x = 40
oldy = 12
oldx = 40

'loop until the condition specified at the end is met
DO

'get the current keypress
k$ = INKEY$

'up
IF k$ = CHR$(0) + CHR$(72) THEN LET y = y - 1: CALL goforward
'left
IF k$ = CHR$(0) + CHR$(75) THEN LET x = x - 1: CALL turnleft
'right
IF k$ = CHR$(0) + CHR$(77) THEN LET x = x + 1: CALL turnright
'down
IF k$ = CHR$(0) + CHR$(80) THEN LET y = y + 1: CALL goback

'make the screen cursor wrap around
IF y < 1 THEN LET y = 23
IF y > 23 THEN LET y = 1
IF x > 79 THEN LET x = 1
IF x < 1 THEN LET x = 79

'draw over the old cursor
IF oldy = y AND oldx = x THEN GOTO nothing ELSE LOCATE oldy, oldx: PRINT " "

nothing:

oldx = x
oldy = y

'draw the new cursor position
LOCATE y, x

o$ = CHR$(177)
PRINT o$

LOCATE 1, 1
PRINT "x="; x
PRINT "y="; y

'exit if escape is pressed
LOOP UNTIL k$ = CHR$(27)


END SUB


SUB setDELAY
REM DELAY LOOP CALCULATION
REM WILL COUNT FOR 1 SECOND
REM MEASURING THE NUMBER OF TIMES THE LOOP GOES ROUND
REM THE RESULT IS DIVIDED BY 10 TO GET THE TIME FOR 10 MILLISECONDS

STARTTIME = TIMER
STARTTIME = STARTTIME + 1


start:
CURRENTTIME = TIMER
COUNT = COUNT + 1
IF CURRENTTIME < STARTTIME THEN GOTO start

delaytime = COUNT / 4

END SUB

SUB turnleft
OUT &H378, 4 + lastdir

FOR i = 0 TO delaytime * 2
NEXT i

OUT &H378, 4

FOR i = 0 TO delaytime * 2
NEXT i


END SUB

SUB turnright
OUT &H378, 8 + lastdir
FOR i = 0 TO delaytime * 2
NEXT i

OUT &H378, 8

FOR i = 0 TO delaytime * 2
NEXT i

OUT &H378, 0


END SUB

