
               TEXT

               INCLUDE       "INIT_TOS.L"
               INCLUDE       "MACROS.L"

               SETBLOCK

               SUPER

               PRINTLINE     MESSAGE
               move.b        #0,$484           ;variable syst�me (mettre
                                               ;0 enl�ve r�p�tition et
                                               ;bip des touches)

TEZT           WAIT

               tst.b         d0
               bne           STP
               swap          d0


               lea           FONCT,a0
               lea           VECTEUR,a1


LISONS         cmp.b         (a0)+,d0


               move.l        (a1)+,a5

               beq           SON

               addq.b        #1,d1
               cmpi.b        #9,d1
               beq           TEZT

               jmp           LISONS



SON            DOSOUND       a5

               jmp           TEZT

STP            USER
               TERM


               DATA

MESSAGE        DC.B          27,'E','Voil� des sons de PRO SOUND DESIGNER'
               DC.B          ', tapez sur les touches de Fonction :',13,10
               DC.B          '( Ou une autre touche pour sortir )',7,0

VECTEUR        DC.L          sound0,sound1,sound2,sound3,sound4,sound5
               DC.L          sound6,sound7,sound8,sound9


FONCT          DC.B          $3B,$3C,$3D,$3E,$3F,$40,$41,$42,$43,$44




;Donn�es d�finissant les sons de PRO SOUND DESIGNER



sound0    DC.B  0,214
          DC.B  1,0
          DC.B  2,215
          DC.B  3,0
          DC.B  4,215
          DC.B  5,0
          DC.B  7,248
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,2
          DC.B  0,0
          DC.B  255,0
sound1    DC.B  0,24
          DC.B  1,1
          DC.B  2,25
          DC.B  3,1
          DC.B  4,23
          DC.B  5,1
          DC.B  7,248
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,2
          DC.B  0,0
          DC.B  255,0
sound2    DC.B  0,156
          DC.B  1,1
          DC.B  2,156
          DC.B  3,1
          DC.B  4,156
          DC.B  5,1
          DC.B  7,248
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,2
          DC.B  0,0
          DC.B  255,0
sound3    DC.B  0,22
          DC.B  1,2
          DC.B  2,21
          DC.B  3,2
          DC.B  4,23
          DC.B  5,2
          DC.B  7,248
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,2
          DC.B  0,0
          DC.B  255,0
sound4    DC.B  0,55
          DC.B  1,3
          DC.B  2,59
          DC.B  3,3
          DC.B  4,57
          DC.B  5,3
          DC.B  7,248
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,2
          DC.B  0,0
          DC.B  255,0
sound5    DC.B  0,235
          DC.B  1,3
          DC.B  2,234
          DC.B  3,3
          DC.B  4,232
          DC.B  5,3
          DC.B  7,248
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,2
          DC.B  0,0
          DC.B  255,0
sound6    DC.B  0,70
          DC.B  1,5
          DC.B  2,72
          DC.B  3,5
          DC.B  4,71
          DC.B  5,5
          DC.B  7,248
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,2
          DC.B  0,0
          DC.B  255,0
sound7    DC.B  0,84
          DC.B  1,7
          DC.B  2,84
          DC.B  3,7
          DC.B  4,84
          DC.B  5,7
          DC.B  7,248
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,2
          DC.B  0,0
          DC.B  255,0
sound8    DC.B  0,175
          DC.B  1,0
          DC.B  2,193
          DC.B  3,4
          DC.B  4,20
          DC.B  5,6
          DC.B  7,254
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,0
          DC.B  93,63
          DC.B  255,0
sound9    DC.B  0,175
          DC.B  1,0
          DC.B  2,193
          DC.B  3,4
          DC.B  4,232
          DC.B  5,4
          DC.B  7,254
          DC.B  8,16
          DC.B  9,16
          DC.B  10,16
          DC.B  11,32
          DC.B  12,73
          DC.B  13,0
          DC.B  129,0
          DC.B  80,88
          DC.B  255,0


               BSS

               DS.B          40000             ;pour SETBLOCK
PILE           DS.B          1
SAUV_SP        DS.L          1



               END



 