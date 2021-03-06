; ROUTINES TO PLOT POINTS & RETURN COLOR VALUES         8/2/89

PLOT:                   ; PASS  SCREENA IN A0
                        ;       X & Y IN D0 & D1
                        ;       COLOR IN D2
        MULU    #((WINDW+1+(2*HBUF))*8),D1    ; VERT ADJUSTMENT
        ADD.L   D1,A0
        MOVE    D0,D1           ; COPY X
        AND     #$FFF0,D0       ; D0 /16 *8
        LSR     #1,D0           ; IZ CHR X
        ADD     D0,A0           ; A0 POINTS TO WORD PT IS IN
        ADD     #8,D0           ; A0 POINTS TO WORD AFTER
        SUB     #$F,D1
        NEG     D1
        AND     #$F,D1          ; D1 IS BIT POS
        MOVE    #4-1,D0
PLOT1:
        MOVE    -(A0),D3
        BTST    D0,D2           ; TEST COLOR BIT
        BEQ     PLOT2           ; BIT CLEAR
        BSET    D1,D3           ; SET BIT
        BRA     PLOT3           ; GO TO END
PLOT2:
        BCLR    D1,D3           ; CLEAR BIT
PLOT3:
        MOVE    D3,(A0)         ; PUT WORD BACK
        DBRA    D0,PLOT1        ; DO ALL 4 PLANES
        RTS

GET:                    ; PASS  SCREENA IN A0
                        ;       X & Y IN D0 & D1
                        ;       COLOR RETURNED IN D2
        MULU    #((WINDW+1+(2*HBUF))*8),D1    ; VERT ADJUSTMENT
        ADD.L   D1,A0
        MOVE    D0,D1           ; COPY X
        AND     #$FFF0,D0       ; D0 /16 *8
        LSR     #1,D0           ; IZ CHR X
        ADD     D0,A0           ; A0 POINTS TO WORD PT IS IN
        ADD     #8,D0           ; A0 POINTS TO WORD AFTER
        SUB     #$F,D1
        NEG     D1
        AND     #$F,D1          ; D1 IS BIT POS
        CLR     D2
        MOVE    #4-1,D0
GET1:
        MOVE    -(A0),D3
        BTST    D1,D3           ; TEST COLOR BIT
        BEQ     GET2            ; BIT CLEAR
        BSET    D0,D2           ; SET BIT
        BRA     GET3            ; GO TO END
GET2:
        BCLR    D0,D2           ; CLEAR BIT
GET3:
        DBRA    D0,GET1         ; DO ALL 4 PLANES
        RTS

        END
 