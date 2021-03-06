; SCROLLING RIVER DRIVER     5/17

MAPW     = 40           ; MAP WIDTH IN CHRS
MAPL     = 132          ; MAP LENGTH
WINDW    = 20           ; SCREEN WINDOW WIDTH IN CHRS
WINDH    = 12           ; SCREEN WINDOW HEIGHT
; SCREENBASE = HARDWARE SCREEN BASE REGISTER              *****

  DATA
  ALIGN
PALETTE IBYTES 'D:\ASSEMPRO\WWM\PALETTE.DAT'
fileprompt:             ; prompt for filename
  dc.b 'Please enter the filename (& pathname if needed) of the',10,13,0
MAPSTR:
  DC.B 'picture file to extract the MAP from.',13,10,0
readingMAP:
  dc.b 10,13,'Reading MAP. ',10,13,10,0
CHRSTR:
  DC.B 'picture file to extract the CHARACTERS from.',13,10,0
readingCHR:
  dc.b 10,13,'Reading CHARACTERS. ',10,13,10,0

input:                  ; adress of input string
  dc.b 64,0
filespec:               ; actual string begins here
  ds.b 64

  BSS
  ALIGN
        DS.B $100
SCREENBUF:              ; 2 SCREEN (+1 SCAN LINE) BUFFER
  DS.B (MAPW*8)*(16*3+(2*WINDH*16))
AFTERSCREENBUF:
SCREENA:        ; SCREEN ADDRESS
        DS.L 1
MAP     DS.B    11528
        DS.B    (40*11*2),0
CHARBASE        DS.B 64000

WINDX:                  ; WINDOW X IN PIXELS IN MAP
  DS.W 1
WINDY:                  ; WINDOW Y IN PIXELS
  DS.W 1
BASEROW:        ; ROW IN MAP THAT OCCUPIES THE TOP LINE OF THE BUFFER
  DS.W 1
X:
  DS.L 1
HANDLE  DS.W    1

  TEXT

  move.l #fileprompt,d0 ; prompt for filename input
  jsr prtline
  move.l #MAPSTR,d0
  jsr prtline

  move.l #input,-(sp)   ; input filename
  move #$a,-(sp)
  trap #1
  addq.l #6,sp

  lea filespec,a0
  move.b #0,(a0,d0.w)   ; null terminate the string

  move #2,-(sp)         ; open file
  move.l #filespec,-(sp)
  move #$3d,-(sp)
  trap #1
  addq.l #8,sp
  move d0,handle

  move.l #readingMAP,d0    ; inform reading
  jsr prtline

  move.l #MAP,-(sp)  ; read
  move.l #11528,-(sp)
  move handle,-(sp)
  move #$3f,-(sp)
  trap #1
  add.l #12,sp

  move handle,-(sp)     ; close file
  move #$3e,-(sp)
  trap #1
  addq.l #6,sp

  move.l #fileprompt,d0 ; prompt for filename input
  jsr prtline
  move.l #CHRSTR,d0
  jsr prtline

  move.l #input,-(sp)   ; input filename
  move #$a,-(sp)
  trap #1
  addq.l #6,sp

  lea filespec,a0
  move.b #0,(a0,d0.w)   ; null terminate the string

  move #2,-(sp)         ; open file
  move.l #filespec,-(sp)
  move #$3d,-(sp)
  trap #1
  addq.l #8,sp
  move d0,handle

  move.l #readingCHR,d0    ; inform reading
  jsr prtline

  move.l #CHARBASE,-(sp)  ; read
  move.l #64000,-(sp)
  move handle,-(sp)
  move #$3f,-(sp)
  trap #1
  add.l #12,sp

  move handle,-(sp)     ; close file
  move #$3e,-(sp)
  trap #1
  addq.l #6,sp

        MOVE.L  #SCREENBUF,D0   ; MAKE SCREEN ON PAGE BOUND FOR ST
        MOVE.B  #0,D0
        MOVE.L  D0,SCREENA

        MOVE    #0,BASEROW
        MOVE.L  #0,X

        MOVE    #0,-(SP)        ; SETSCREEN RES
        MOVE.L  SCREENA,-(SP)
        MOVE.L  SCREENA,-(SP)
        MOVE    #5,-(SP)
        TRAP    #14
        ADD.L   #12,SP

        MOVE.L  #PALETTE,-(SP)
        MOVE    #6,-(SP)
        TRAP    #14
        ADDQ.L  #6,SP
LOOP:
        JSR     INITSCREEN

        MOVE    #7,-(SP)
        TRAP    #1
        ADDQ.L  #2,SP
        SWAP    D0

UP      CMP.B   #$48,D0 ; UP
        BNE     DOWN
        SUB     #WINDH,BASEROW
        BGE     LOOP
        CLR     BASEROW
        JMP     LOOP

DOWN    CMP.B   #$50,D0 ; DOWN
        BNE     LEFT
        ADD     #WINDH,BASEROW
        JMP     LOOP

LEFT    CMP.B   #$4B,D0 ; LEFT
        BNE     RIGHT
        SUB.L   #2*WINDW,X
        JMP     LOOP

RIGHT   CMP.B   #$4D,D0 ; RIGHT
        BNE     LOOP
        ADD.L   #2*WINDW,X
        JMP     LOOP

INITSCREEN:             ; FILL SCREEN BUFFER WITH GRAPHICS FROM
                        ; THE CHARACTER MAP.
                        ; THE ONLY PARAMETER REQUIRED IS BASEROW.
  LEA MAP,A0            ; FETCH MAP ABSE ADR
  MOVE BASEROW,D0       ; FIND THE BASE ROW
  MULU #MAPW*2,D0       ; IN THE MAP
        ADD.L   X,A0
  ADD.L D0,A0           ; A0 IS NOW CURRENT MAP POINTER

  MOVE.L SCREENA,A1     ; A1 IS SCREENBUFFER POINTER

  LEA CHARBASE,A2       ; A2 IS POINTER TO CHARACTER SET

  MOVE #(WINDH+1)-1,D7  ; LOOP 11 CHARACTER LINES (10+SCRATCH ZONE)
NEXTROW:
  MOVE #WINDW-1,D6       ; CHARACTERS PER LINE
NEXTCOL:
        CLR.L D0
        MOVE (A0)+,D0         ; FETCH CHARACTER #
        LSL.L   #7,D0           ; AND MULT BY 128 (CHARLEN IN BYTES)
        CLR D1
        MOVE #16-1,D5         ; 16 LINES PER CHR
DRAWCHR:
  MOVE.L 0(A2,D0.L),0(A1,D1.W) ; COPY 1 LINE IN TOP AREA
  MOVE.L 4(A2,D0.L),4(A1,D1.W)
  ADD.L #8,D0             ; NEXT CHR LINE
  ADD #WINDW*8,D1        ; NEXT SCREEN LINE             MAPW
  DBRA D5,DRAWCHR
  ADD.L #8,A1           ; NEXT CHR TO THE RIGHT ON THE SCREEN
  DBRA D6,NEXTCOL
  ADD.L #(WINDW*8*15),A1 ; NEXT ROW                     MAPW
        ADD.L   #20*2,A0
  DBRA D7,NEXTROW
  RTS

prtline:
  move.l d0,-(sp)
  move #$09,-(sp)
  trap #1
  addq.l #6,sp
  rts

        END

 