;
;------------------------------------------------------------------------------
;                       INITIALIZE AND ANIMATE MINE
;------------------------------------------------------------------------------
;
MINEINIT:
        BTST       #0,MINEFLG1
        BNE        MII3
        LEA        MINEPARM1,A0                ;GET BB PARMS
        MOVE.W     WINDY,D0                ;GET SCREEN WINDOW YCORD
        AND.W      #$FFF0,D0
        ADD.W      #(12*16),D0                ;MOVE DOWN 7 BLOCKS
        MOVE.W     D0,YCORD(A0)                ;SET YCORD

        MOVE    #3-1,D3         ; # OF TIMES TO LOOK FOR H2O
MII2D:
        JSR     FRANDOM         ; LOOK FRANDOMLY
        MOVE.B  D0,D1
        LSL     #1,D1
        JSR     FRANDOM
        EOR.W   D1,D0
        AND     #$1FF,D0
        ADD.B   #(640-512)/2,D0
        MOVE    D0,D2
        JSR     FIND_CHAR
        CMPI.W  #236,D0                  ;OVER WATER?
        BLS     MII2C                ; BINGO! GO STORE PARMS
        DBRA    D3,MII2D
        RTS                             ; NO DICE...EXIT
MII2C:
        MOVE.W     D2,XCORD(A0)                ;SET XCORD
        MOVE.B     #1,MINEFLG1                ;SET BB FLAG ACTIVE
MII0:
        RTS
;
MII3:
        BTST       #0,STIMER+3             ;EVERY OTHER
        BEQ        MII0
        LEA        MINEPARM1,A1
        ADDQ.B     #1,ANIMSEQ(A1)
        CMPI.B     #2,ANIMSEQ(A1)
        BLS        MII4
        CLR.B      ANIMSEQ(A1)
MII4:
        MOVE.W     WINDY,D0
        SUB.W      #$F,D0
        CMP.W      YCORD(A1),D0
        BLS        MII5
        CLR.B      MINEFLG1
        RTS
MII5:
        LEA        SHIPPARM,A2               ;CHECK FOR COLLISION WITH SHIP
        MOVE.W     XCORD(A2),D0
        MOVE.W     D0,D1
        MOVE.W     YCORD(A2),D2
        MOVE.W     D2,D3
        ADDI.W     #$8,D1
        ADDI.W     #$8,D3
        SUB     #$8,D0
        SUB     #$8,D2

        CMP.W      XCORD(A1),D1
        BLT        MII0
        CMP.W      YCORD(A1),D3
        BLT        MII0

        CMP.W      XCORD(A1),D0
        BHI        MII0
        CMP.W      YCORD(A1),D2
        BHI        MII0
        CLR.B      MINEFLG1                  ;WE HAVE A COLLISION WITH SHIP
        JMP        FTEND2                    ;SET EXPLOSION

    END
 