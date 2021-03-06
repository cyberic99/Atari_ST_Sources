;~~~~~~~~~~~~~~~~~~~~~~~~ S ~ T ~ R ~ O ~ B ~ O ~ S ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; V1.00

; Permet le basculement entre l'�cran courant et 2 autres �crans
; pour �viter les interf�rences avec le faisceau lors de l'affichage.
; L'appel doit se faire en Superviseur par jsr Strobos

; INIT: D0.L =           Strobos(-1 , Ecran1.L , Ecran2.L )
;       Ecran de travail              Adresses de 2 �crans

; BASC: D0.L =           Strobos( 1 , D�part , Taille )
;       Ecran de travail              D�part:Adresse /d�part pour copie E1>>>E2
;                                              Taille:de la partie � copier

; FIN:  D0.L =           Strobos( 0 )
;       Ecran de travail

V_BH  =$FFFF8200
V_BM  =$FFFF8202
V_BL  =$FFFF820C
V_CH  =$FFFF8204
V_CM  =$FFFF8206
V_CL  =$FFFF8208
B_CR  =$FFFF8A3C
B_OR  =$FFFF8A3A
B_SA  =$FFFF8A24
B_DA  =$FFFF8A32
B_HC  =$FFFF8A36
B_VC  =$FFFF8A38
B_SHI =$FFFF8A20
B_SVI =$FFFF8A22
B_DHI =$FFFF8A2E
B_DVI =$FFFF8A30
B_BM  =$FFFF8A28
B_MM  =$FFFF8A2A
B_EM  =$FFFF8A2C
K_CTL =$FFFFFC00
K_DAT =$FFFFFC02
I_ISRB=$FFFFFA10
I_TCDR=$FFFFFA22

_v_bas_ad=$44E
_cookie  =$5A0
_hz_200  =$4BA

 DATA

STE DC.B 0 ; 0:ST  -1:STE
E_o DS.L 1 ;originel
E_0 DS.L 1
E_1 DS.L 1
E_2 DS.L 1

 TEXT
STROBOS: tst 4(SP)
 bmi Init
 beq Fin
 bpl Basc

Init:
 ;machine ?
 lea STE(PC),A3
 move.l _cookie,D0
 beq \1
 movea.l D0,A0
\3 tst.l (A0)
 beq \1
 cmpi.l #'_MCH',(A0)+
 beq \2
 addq #4,A0
 bra \3
\2 cmpi #1,(A0)
 bne \1
 st (A3)
\1 ;init E_o E_0 E_1 E_2
 clr.l D0
 lea V_BH,A0
 movep 1(A0),D0
 asl.l #8,D0
 tst.b (A3)
 beq \4
 move.b V_BL+1,D0
\4 lea E_o(PC),A0
 move.l D0,(A0)+
 move.l D0,(A0)+
 move.l  6(SP),(A0)+
 move.l 10(SP),(A0)
 ; copie dans E_1
 movea.l E_0(PC),A3
 movea.l E_1(PC),A4
 move #32000,D3
 bsr copieA3A4_D3
 ; copie dans E_2
 movea.l E_0(PC),A3
 movea.l E_2(PC),A4
 move #32000,D3
 bsr copieA3A4_D3
 ;�cran travail
 move.l E_1(PC),D0
 move.l D0,_v_bas_ad
 rts

Basc:
 lea STE(PC),A0
 ; changer VB sans �tre proche du VSYNC
 clr D0
 tst.b (A0)
 beq \1
 move.b V_BL+1,D0
\1 cmp.b V_CL+1,D0 ;dans bande inf. ! (ou fausse alerte)
 beq \1
 movea.l E_1(PC),A3
 move.l A3,D0
 move.b D0,D1
 lsr.l #8,D0
 lea V_BH,A1
 move SR,D7
 ori #$0700,SR
 movep D0,1(A1)
 tst.b (A0)
 beq \2
 move.b D1,V_BL+1
\2 move D7,SR
 ; copier la partie
 adda 6(SP),A3
 movea.l E_2(PC),A4
 adda 6(SP),A4
 move 8(SP),D3
 cmpi #4,D3
 blo \3
 bsr copieA3A4_D3

\3 ; rotation sur 3 valeurs
 lea  E_0(PC),A0
 move.l  (A0),D1
 move.l 4(A0), (A0)
 move.l 8(A0),D0
 move.l    D0,4(A0)
 move.l    D1,8(A0)
 move.l    D0,_v_bas_ad

 ; attendre pour nouvel �cran
 ; �viter parasitage d� � la coupure de VC ou au VSYNC
 lea V_CH,A0
\5 move SR,D7
 ori #$0700,SR
 movep.l 1(A0),D1
 movep.l 1(A0),D2
 move D7,SR
 lsr.l #8,D1
 lsr.l #8,D2
 sub.l D2,D1
 bpl \4
 neg.l D1
\4 cmpi.l #78,D1 ; 8<valeur<248
 bhi \5
 sub.l E_0(PC),D2
 bmi \5
 cmpi.l #32000,D2
 bhi \5
 rts

Fin: lea E_o(PC),A0
 lea E_0(PC),A1
 cmpm.l (A0)+,(A1)+
 beq \1
 move #32000,-(SP)
 clr         -(SP)
 move #1    ,-(SP)
 bsr Basc
 addq #6,SP
 bra Fin
\1 move.l E_o(PC),D0
 move.l D0,_v_bas_ad
 rts

copieA3A4_D3: ;D3=Taille  ... au mot long pr�s.
 lea STE(PC),A0
 tst.b (A0)
 bne Blib
Cpu: move D3,D0
 lsr #8,D0 ;nbre de rafales de 256 octets
 move D3,D1
 andi #$FF,D1
 lsr #2,D1 ;nbre de rafales de 4 octets
 subq #1,D0
 bmi \2
 movea #32,A5
\1 ;rafale de 256 octets
 movem.l (A3)+,D3-A2
 movem.l D3-A2,(A4)
 adda A5,A4
 movem.l (A3)+,D3-A2
 movem.l D3-A2,(A4)
 adda A5,A4
 movem.l (A3)+,D3-A2
 movem.l D3-A2,(A4)
 adda A5,A4
 movem.l (A3)+,D3-A2
 movem.l D3-A2,(A4)
 adda A5,A4
 movem.l (A3)+,D3-A2
 movem.l D3-A2,(A4)
 adda A5,A4
 movem.l (A3)+,D3-A2
 movem.l D3-A2,(A4)
 adda A5,A4
 movem.l (A3)+,D3-A2
 movem.l D3-A2,(A4)
 adda A5,A4
 movem.l (A3)+,D3-A2
 movem.l D3-A2,(A4)
 adda A5,A4
 dbra D0,\1

\2 subq #1,D1
 bmi \f
 ;rafale de 4 octets
\3 move.l (A3)+,(A4)+
 dbra D1,\3
\f rts

Blib:
;----------------------------------------------
;Pour mode Blitter seul , � d�velopper
 ; move.b    #19,K_DAT ;plus de codes envoy�s !

 ;et on le v�rifie ... (plus de 2 ms sans code)

 ; lea I_TCDR+1,A0
 ; clr D0
 ; clr D2
 ;\2 move.b (A0),D0 ;Entr�e
 ; move D0,D1
 ; cmpi #78,D1
 ; bhi  \1
 ; addi #192,D1
 ;\1 subi #78,D1  ;Sortie
 ;\5 btst #6,I_ISRB+1
 ; bne \2
 ; move.b (A0),D2
 ; cmp D1,D0
 ; bls \3
 ; cmp D0,D2
 ; bhi \4
 ; cmp D1,D2
 ; bls \4
 ; bra \5

 ;\3 cmp D0,D2
 ; bls \5
 ; cmp D1,D2
 ; bhi \5

 ; Autre m�thode , mais plus lente ...
 ; lea _hz_200,A0
 ;\1 moveq #1,D0
 ; add.l (A0),D0
 ;\2 btst #6,I_ISRB+1
 ; bne \1
 ; cmp.l (A0),D0
 ; bhs \2
;----------------------------------------------

\4 move D3,D0
 asr #2,D0 ;on en refile 1/4 au MC68000
 andi #$FFFC,D0 ;divisible par 4
 sub D0,D3
 move   #$0203,B_OR
 move.l     A3,B_SA
 move.l     A4,B_DA
 adda D3,A3
 adda D3,A4
 asr #1,D3
 move       D3,B_HC
 move       #1,B_VC
 move       #2,B_SHI
 move       #0,B_SVI
 move       #2,B_DHI
 move       #0,B_DVI
 move   #$FFFF,B_BM
 move   #$FFFF,B_MM
 move   #$FFFF,B_EM
 move   #$8000,B_CR  ;BLIT ! mode partag� h�las ...
 move D0,D3
 bsr Cpu
\6 btst     #7,B_CR
 bne \6

 ; move.b    #17,K_DAT ;On peut r�utiliser le clavier
 rts

 END

 