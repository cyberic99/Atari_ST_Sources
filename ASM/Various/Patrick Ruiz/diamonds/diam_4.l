; comme DIAMONDS mais en 80x50
; V0.24

 ILABEL D:\PROFIMAT\GEM.BIB
ESC=27

 ;SCRN_GRES
        move #4,-(SP)
        trap #14
        addq #2,SP
        tst D0
        beq DEPART2

FIN2: ;PROG_END
        clr -(SP)
        trap #1

DEPART2:
 ;efface le curseur
        CONS_OUT #2,#27
        CONS_OUT #2,#'f'
        SCRN_WVBL
 ;PROG_SUPER
        pea GETPALETTE
        move #38,-(SP)
        trap #14
        addq #6,SP
 
 ;SCRN_SPALETTE
        pea palette
        move #6,-(SP)
        trap #14
        addq #6,SP

        PROG_SUPERMODE #0
        move.l D0,PAD

        lea TAB_T,A0
        lea TAB_1,A1
        lea TAB_2,A2
        move.l A1,(A0)+
        move.l A2,(A0)

        lea ECR_M+256(PC),A0
        move.l A0,D0
        clr.b D0
        move.l D0,-(SP)
        move #-1,-(SP)
        bsr STROBOS
        addq #6,SP
        move.l D0,ECR_T

DIAMONDS:
 ;~~~ ---> TAB
        movea.l TAB_T,A3
\1      movea.l A3,A4
        adda #80+2+1,A3
        move #80/2-1,D3 ;col.
        move #50-1,D4 ;lign.
        move #$F0F,D5 ;masque
\hz     move #17,-(SP)
        trap #14
        addq #2,SP
        lsr.l #3,D0 ;allons savoir
        and D5,D0
        move D0,(A3)+
        dbra D3,\hz
        move #80/2-1,D3
        addq #2,A3
        dbra D4,\hz
;lign. -1 et 50
        movea.l A4,A3
        addq #1,A3
        move.l #50*82,D0
        move #80-1,D3
\L_1    move.b (A3,D0.L),(A3)+
        dbra D3,\L_1
        movea.l A4,A3
        adda.l #51*82+1,A3
        move #80-1,D3
        neg.l D0
\L50    move.b (A3,D0.L),(A3)+
        dbra D3,\L50
 ;col. -1 et 80
        movea.l A4,A3
        adda #82,A3
        move #50-1,D4
\C_1    move.b 160(A3),(A3)
        adda #82,A3
        dbra D4,\C_1
        movea.l A4,A3
        adda #82+80+1,A3
        move #50-1,D4
\C80    move.b -80(A3),(A3)
        adda #82,A3
        dbra D4,\C80
        bra remp
gen: ; CRISTAL 
        movea.l TAB_T+4,A0
        movea.l TAB_T,A1
\suite:               ;A0=TAB srce
                      ;A1=TAB dest
        movea.l A0,A2
        adda #82+1,A2 ;A2=ptr srce
        movea.l A1,A3
        adda #82+1,A3 ;A3=ptr dest
        move #80-1,D0 ;D0=col.
        move #50-1,D1 ;D1=lign.
        moveq #-  1,D2 ;D2=offset G
        moveq #   1,D3 ;D3=offset D
        movea #  82,A4 ;A4=offset H
        movea #- 82,A5 ;A5=offset B
\np     move.b (A2)+,D4 ;D4=coul pixel
        move.b D4,D5   ;D5=coul nouv pixel
        moveq #$F,D6   ;D6=masque mod16
        addq #1,D5
        and.b D6,D5
        cmp.b -1(A2,D2),D5
        beq \sq ;saut quantique!
        cmp.b -1(A2,D3),D5
        beq \sq
        cmp.b -1(A2,A4),D5
        beq \sq
        cmp.b -1(A2,A5),D5
        beq \sq
        move.b D4,D5 ;rien de neuf
\sq     move.b D5,(A3)+
        dbra D0,\np
        addq #2,A2
        addq #2,A3
        move #80-1,D0
        dbra D1,\np

; report sph�rique
;lign. -1 et 50
        movea.l A1,A0 ;A1=TAB ... autres=brouillon
        addq #1,A0
        move.l #50*82,D0
        move #80-1,D1
\L_1    move.b (A0,D0.L),(A0)+
        dbra D1,\L_1
        movea.l A1,A0
        adda.l #51*82+1,A0
        move #80-1,D1
        neg.l D0
\L50    move.b (A0,D0.L),(A0)+
        dbra D1,\L50
 ;col. -1 et 80
        movea.l A1,A0
        adda #82,A0
        move #50-1,D1
\C_1    move.b 80(A0),(A0)
        adda #82,A0
        dbra D1,\C_1
        movea.l A1,A0
        adda #82+80+1,A0
        move #50-1,D1
\C80    move.b -80(A0),(A0)
        adda #82,A0
        dbra D1,\C80
remp: ;TAB ---> ECR
        movea.l TAB_T,A0
\suite  adda #82+1,A0       ;A0=srce
        movea.l ECR_T,A1    ;A1=dest
        move #80/2-1,D0     ;D0=col.
        move #50-1,D1       ;D1=lign.
        move #$8000,D5      ;D2/D3/D4/D5=plans avec D5 indic. d�bordement
\nsp    move.b (A0)+,D6 ;D6=coul 1
        move.b (A0)+,D7     ;D7=coul 2
        lsr.b #1,D6
        roxr #1,D2
        asr #3,D2
        lsr.b #1,D6
        roxr #1,D3
        asr #3,D3
        lsr.b #1,D6
        roxr #1,D4
        asr #3,D4
        lsr.b #1,D6
        roxr #1,D5
        asr #3,D5
        lsr.b #1,D7
        roxr #1,D2
        asr #3,D2
        lsr.b #1,D7
        roxr #1,D3
        asr #3,D3
        lsr.b #1,D7
        roxr #1,D4
        asr #3,D4
        lsr.b #1,D7
        roxr #1,D5
        asr #3,D5
        dbcs D0,\nsp
 ;inverser D2/D3/D4/D5  ... D6/D7 ne servent pas ici
        moveq #15,D6
\bc2    lsr #1,D2
        roxl #1,D7
        dbra D6,\bc2
        move D7,D2
        moveq #15,D6
\bc3    lsr #1,D3
        roxl #1,D7
        dbra D6,\bc3
        move D7,D3
        moveq #15,D6
\bc4    lsr #1,D4
        roxl #1,D7
        dbra D6,\bc4
        move D7,D4
        moveq #15,D6
\bc5    lsr #1,D5
        roxl #1,D7
        dbra D6,\bc5
        move D7,D5
        move D2,(A1)+ ;vidage
        move D2,160-2(A1)
        move D2,320-2(A1)
        move D2,480-2(A1)
        move D3,(A1)+
        move D3,160-2(A1)
        move D3,320-2(A1)
        move D3,480-2(A1)
        move D4,(A1)+
        move D4,160-2(A1)
        move D4,320-2(A1)
        move D4,480-2(A1)
        move D5,(A1)+
        move D5,160-2(A1)
        move D5,320-2(A1)
        move D5,480-2(A1)
        move #$8000,D5
        dbra D0,\nsp
        addq #2,A0
        adda #480,A1
        move #80/2-1,D0
        dbra D1,\nsp
basc: ;Normal <|> Miroir
        move #1,-(SP)
        bsr STROBOS
        addq #2,SP
        move.l D0,ECR_T
        lea TAB_T,A0
        move.l (A0),D0
        move.l 4(A0),D1
        move.l D0,4(A0)
        move.l D1,(A0)

attente: ;CONS_GINSTAT
        move #2,-(SP)
        move #1,-(SP)
        trap #13
        addq #4,SP
        tst D0
        beq gen
 ;CONS_IN
        move #2,-(SP)
        move #2,-(SP)
        trap #13
        addq #4,SP
        cmpi.b #127,D0
        beq DIAMONDS
        cmpi.b #ESC,D0
        bne attente

EPILOGUE:
        move #0,-(SP)
        bsr STROBOS
        addq #2,SP
 ;SCREEN_SPALETTE
        pea palette_orig
        move #6,-(SP)
        trap #14
        addq #6,SP
        PROG_SUPERMODE PAD
        bra FIN2

GETPALETTE: lea $FFFF8240,A0
        lea palette_orig,A1
        moveq #15,D0
\t      move (A0)+,(A1)+
        dbra D0,\t
        rts

STROBOS: IBYTES F:STROBOS2.B

 _D
palette DC.W $000,$200,$300,$400,$500,$600,$700,$732
        DC.W $742,$752,$652,$552,$770,$773,$775,$777

 _M
palette_orig DS.W 16
ECR_T   DS.L 1   ;Ecran de travail
TAB_T   DS.L 1+1 ;Tableau de travail

        ALIGN
        DS.B 1 ;"r�aligner" les TAB
TAB_1   DS.B (80+2)*(50+2)
TAB_2   DS.B (80+2)*(50+2)

        ALIGN
ECR_M   DS.B 32000+256
 END
 