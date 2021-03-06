;                         ~ BLUE METAL DEMO ~

;                             (C) METAL68              le 28/04/88
;                            ~~~~~~~~~~~~~

                              org $20000

; mode superviseur

superv move.l #$80000,-(sp)    ; pile superviseur en $80000
       move.w #$20,-(sp)
       trap   #1
       addq.l #6,sp

; basse resolution

basrez move.w #0,-(sp)         ; mode basse resolution
       move.l #$70000,-(sp)    ; base physique et logique de
       move.l #$70000,-(sp)    ; l'ecran en $70000
       move.w #5,-(sp)
       trap   #14
       adda.l #12,sp


; deconnection de la souris

nomous move.l #mouse,-(sp)     ; adresse de la chaine a envoyer
       move.w #0,-(sp)         ; longueur de la chaine -1
       move.w #25,-(sp)
       trap   #14
       addq.l #8,sp

       bsr ch_mes              ; codage du message

       andi.b  #$f8,$484       ; bit0 et bit2 = 0 touches non sonores

;deplacer le WELCOME !

depwel movea.l #$77D00,a0      ; adresse ecran (voir interruption int4)
       movea.l #$551E0,a1      ; adresse de WELCOME!
       move.w  #559,d0         ; hauteur = 28 lignes
depwe1 move.l  (a1),(a0)+
       clr.l   (a1)+           ; effacer l'original (pour raison d'aff)
       move.l  (a1),(a0)+
       clr.l   (a1)+
       dbra    d0,depwe1

       bsr razbuf              ; mise a zero des buffers du scrolling
       bsr detour              ; detourner les vecteurs d'interruption

       move.l #sprite,$4CE     ; listes des taches a effectuer lors
       move.l #mv,$4D2         ; d'interruptions VBL (image)
       move.l #decol,$4d6
       move.l #scrolling,$4DA
       move.l #music,$4DE
       move.l #welcome,$4E2

       move.w #1,$452          ; autorise l'execution de s-prog
       move.w #6,$454          ; 6 s-prog a executer

debut  bsr inkey               ; Ici programme principale
       bra debut               ; Si Si c'est vrai !!!!

inkey  move.w #$FF,-(sp)
       move.w #6,-(sp)         ; scruter le clavier
       trap #1
       addq.l #4,sp
       cmpi.b #'0',d0          ; est ce la touche '0'
       beq fin                 ; si oui alors Reset
       rts

fin    jmp $FC0020             ; RESET

;codage du texte a scroller

ch_mes movea.l #message,a0     ; pointe le texte a coder
       movea.l #codage,a1      ; pointe la table des codes
       moveq   #0,d0
ch_me1 move.b  (a0),d0         ; charge la lettre
       subi.b  #$20,d0         ; je commence par ESP (donc ESP=0)
       move.b  (a1,d0.w),(a0)+ ; remplace la lettre par son code
       cmpi.b  #$3B,d0         ; est-ce la fin
       bne ch_me1              ; non continuer
       rts

;Remise a zero des buffers du scrolling

razbuf movea.l deb_buf,a0      ; Debut des buffers
       moveq   #0,d1           ; remplir avec 0
       move.l  #1344,d0
razb1  move.l  d1,(a0)+
       move.l  d1,(a0)+
       dbra    d0,razb1
       rts

deb_buf:dc.l tab_buf

tab_buf = $30000

buf1 = tab_buf+160*16*0
buf2 = tab_buf+160*16*1
buf3 = tab_buf+160*16*2
buf4 = tab_buf+160*16*3

tab_st = tab_buf+160*16*4

st1 = tab_st+8*16*0 
st2 = tab_st+8*16*1
st3 = tab_st+8*16*2
st4 = tab_st+8*16*3


;Gestion du scrolling vertical de METAL68

sprite bsr decal               ; decaler tout le sprite
       bsr scrov               ; afficher la ligne suivante
       rts

scrov  movea.l adligb,a6       ; adresse du bas de METAL68
       add.l   #160,adligne    ; ligne du sprite a afficher
       movea.l adligne,a5
       cmpa                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                etourne les interruption de lignes (HBL)

       ori.b  #1,$FFFA07       ; autorise une interruption du timer B
       ori.b  #1,$FFFA13       ; interruption B non masquee
       move.l $70,vbl3+2
       move.l #vbl,$70         ; detourne les interruptions VBL (image)
       rts
;------------------------------------------------------------------------
;                interruption acia (clavier ou midi)
;------------------------------------------------------------------------

intacia move.w #$2300,sr       ; possibilite d'interruption lors du
itacia  jmp $FC281C            ; traitement

;-----------------------------------------------------------------------
;                        interruption d'image VBL
;-----------------------------------------------------------------------

vbl    movem.l d0/a0/a1,-(sp)  ; sauvegarde des registres
       clr.b   $FFFA1B         ; arret du timer B
       move.b  #1,$FFFA21      ; prochaine interruption dans 1 ligne
       move.b  #8,$FFFA1B      ; Timer B en mode compteur
       move.l  #int,$120       ; detourner l'interrupt HBL

       movea.l #couleur,a0
       movea.w #$8240,a1       ; initialise les couleurs de la palette
       moveq #3,d0             ; normale
vbl2   move.l (a0)+,(a1)+
       move.l (a0)+,(a1)+
       dbra d0,vbl2

       move.l  #col,stock1     ; pointe la prochaine adresse de la couleur
       movem.l (sp)+,d0/a0/a1  ; restiteur les registres
vbl3   jmp     $FC0634         ; execution des autres evenements

;-----------------------------------------------------------------------
;            interruption du compteur de lignes timer B (HBL)
;-----------------------------------------------------------------------

int    clr.b   $FFFA1B         ; arret du timer B
       movem.l d0/a0/a1,-(sp)  ; sauvegarde des registres
       movea.w #$8240,a0       ; palette couleur
       movea.l stock1,a1       ; adresse de la couleur
       cmpa.l  #col1,a1
       beq     int2
       moveq   #2,d0           ; prochaine interruption dans 2 lignes
       move.b  d0,$FFFA21      ; charger la donnee de decomtage
       move.b  #8,$FFFA1B      ; timer en mode Event Count

in1    cmp.b $FFFA21,d0        ; attendre que le timer B ait fini de
       beq in1                 ; de compter le nombre de lignes voulu
       bsr     attente         ; petite attente
       move.w  (a1)+,(a0)      ; changer la couleur 0
       move.l  a1,stock1       ; pointe la couleur suivante
       movem.l (sp)+,d0/a0/a1  ; restituer les registres
       bclr    #0,$FFFA0F      ; autorise une nouvelle interruption de B
       rte

;-----------------------------------------------------------------------
;                    2eme interruption HBL   ( bande texte )
;-----------------------------------------------------------------------

int2   move.b  #86,$FFFA21     ; prochaine interruption dans 86 lignes
       move.b  #8,$FFFA1B      ; timer en mode Event Count

       move.b $FFFA21,d0
in21   cmp.b  $FFFA21,d0       ; attendre que le timer B ait fini de
       beq in21                ; de compter le nombre de lignes voulu
       bsr attente             ; petite attente

       moveq #3,d0             ; changer toute la palette de couleur
in22   move.l (a1)+,(a0)+
       move.l (a1)+,(a0)+      ; restituer les registres
       dbra d0,in22

       movem.l (sp)+,d0/a0/a1
       move.l  #int3,$120      ; prochaine interruption traitee par int3
       bclr    #0,$FFFA0F      ; autorise une nouvelle interruption de B
       rte

;-----------------------------------------------------------------------
;                    3eme interruption HBL   ( scrolling de couleurs )
;-----------------------------------------------------------------------

int3   clr.b   $FFFA1B         ; arret du timer B
       movem.l d0-a2,-(sp)     ; sauvegarde des regitres
       movea.l ptcol2,a0       ; pointeur sur la couleur courante
       movea.w #$8240,a1
       movea.w #$FA21,a2
       move.b  #2,(a2)         ; 2 dans le registre de donnees
       move.b  #8,$FFFA1B      ; mode Event Count

       moveq   #48,d0          ; 48 lignes de couleurs differentes
in31   move.w (a0)+,d4         ; charger la couleur
       move.b (a2),d5          ; attendre que le timer ait compter
in32   cmp.b  (a2),d5          ; une ligne
       beq    in32
       bsr attente
       move.w  d4,(a1)         ; changer la couleur 0
       cmpa.l  #finc,a0        ; est ce la fin des couleur
       bne     in33
       movea.l #debc,a0        ; si oui pointer sur le debut
in33   dbra d0,in31

       movea.l #colext,a0      ; pointe sur les couleurs de WELCOME
       move.b (a2),d5          ; attendre que le timer ait compter
in36   cmp.b  (a2),d5          ; une ligne
       beq    in36

       moveq #3,d0             ; changer toute la palette de couleur
in35   move.l (a0)+,(a1)+
       move.l (a0)+,(a1)+
       dbra d0,in35

       movem.l (sp)+,d0-a2     ; restituer les registres
       move.b #1,$FFFA21       ; interruption dans une ligne
       move.l #int4,$120       ; traitee par int4
       bclr    #0,$FFFA0F      ; autorise une nouvelle interruption de B
       rte

;-----------------------------------------------------------------------
;                    4eme interruption HBL   ( bordure du bas )
;-----------------------------------------------------------------------

;        Interruption permettant d'ecrire dans la bordure du bas
;       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Principe : au milieu de la derniere ligne video, on passe a 60Hz
; ~~~~~~~~   puis a la fin de la ligne on revient a 50Hz -> le shifter
;            video se plante dans ses calculs d'adresses puis continue
;            a decoder la RAM et l'envoie a la video; c'est pourquoi
;            la memoire video a ete reculee afin de permettre a environ
;            50 lignes d'etre ajoutees (50*160=8000 octets env).
;            une ligne est balayee en 1280 cycles machine

int4   move.l a4,-(sp)         ; sauvegarde des registres
       move.l d0,-(sp)
       move.w #$FA21,a4        ; a4 pointe sur le Timer B
       clr.b -6(a4)            ; arret du Timer
       move.b #100,(a4)        ; prochaine interruption dans 100 lignes
                               ; ( en dehors de l'ecran )
       move.b #8,-6(a4)        ; Timer en mode compteur

       move.b (a4),d0
in41   cmp.b  (a4),d0          ; attendre que le balayage de la ligne actuelle
       beq in41                ; soit termine
       moveq #10,d0            ; attendre le milieu de ligne (a peu pres)
in43   bsr attent1
       dbra d0,in43

       clr.b $FF820A           ; passer en 60Hz

       move.b (a4),d0
in42   cmp.b (a4),d0           ; attendre la fin du balayage de la ligne
       beq in42
       bsr attente             ; attente

       move.b #2,$ff820A       ; passer en 50Hz

       move.l (sp)+,d0         ; restituer les registres
       move.l (sp)+,a4
       bclr #0,$fffa0f         ; autorise une prochaine interruption de B
       rte

attente nop
        nop
        nop
        nop
        nop
attent1 rts



;Gestion du scrolling horizontal
;-------------------------------

scrolling:move.w branch,D2      ;No de la routine a executer (de 0 a 4)
          addq.w #1,branch      ;+1 pour le prochain appel  (de 0 a 4)
          cmpi.w #3,d2          ;est-ce la routine 4 ?
          bne scrollin1         ;non alors continuer
          clr.w branch          ; si oui alors RAZ de branch
scrollin1:asl.w #2,d2           ; *4 (adresse sur 4 octets)
          movea.l #adresse,a2   ; table d'adresse des routines(ad1-ad8)
          movea.l 0(a2,d2.w),a2 ; pointer sur la routine
          jmp (A2)              ; executer

ad1: movea.l #buf4,a6    ; afficher le buffer 4
     bsr scroh
     movea.l #buf3,a6    ; decaler d'une lettre le buffer 3
     movea.l #st3,a5
     bra scrolh

ad2: movea.l #buf3,a6
     bsr scroh
     movea.l #buf2,a6
     movea.l #st2,a5
     bra scrolh


ad3: movea.l #buf2,a6
     bsr scroh
     movea.l #buf1,a6
     movea.l #st1,a5
     bra scrolh


ad4:movea.l #buf1,a6        ; afficher le buffer 1
    bsr scroh

    movea.l #message,a0     ;a0 pointe sur le debut du message
    movea.l #lettres,a1     ;a1 pointe sur la table d'adresse des lettres

scrolh1: move.w  cmpt_let,d0    ; d0 contient le No de la lettre a traiter
         move.b  (a0,d0.w),d1   ; d1 contient le code de la lettre
         cmpi.b  #51,d1         ; est-ce fin de chaine
         bne    scrolh2         ; non alors continuer
         clr.w  cmpt_let        ; si oui alors mettre le compteur a 0
         bra scrolh1            ; recommencer

scrolh2: ext.w d1                ; mettre format 16 bits (pour calcul)
         asl.w #2,d1             ; d0*4  (4 octets d'adresse)
          move.l 0(a1,d1.w),mem1 ; stocker l'adresse du sprite de cette
                                 ; lettre dans mem1
         addq.w #1,cmpt_let      ; incrementer le compteur de lettres
         move.w cmpt_let,d0
         move.b  (a0,d0.w),d1    ; d1 contient le code de la 2eme lettre
         cmpi.b  #51,d1          ; est-ce fin de chaine
         bne    scrolh3          ; non alors continuer
         move.b (a0),d1          ; si oui alors mettre le compteur a 0
scrolh3: ext.w d1                ; mettre format 16 bits (pour calcul)
         asl.w #2,d1
         move.l 0(a1,d1.w),mem2  ; stocker l'adresse du sprite de cette
                                 ; lettre dans mem2
         bsr masque            ;faire les rotations

         movea.l #buf4,a6       ; decaler d'une letter le buffer 4
         movea.l #st4,a5       

;decalage d'une lettre vers la gauche

scrolh:  moveq   #15,d0        ; hauteur de la bande
scrolh4: movem.l 8(a6),d1-a4   ; decalage de 152 octets par lignes
         movem.l d1-a4,0(a6)   ; de 8 octet vers la gauche
         movem.l $38(a6),d1-a4 ;
         movem.l d1-a4,$30(a6) ; ca correspond a faire un decalage de
         movem.l $68(a6),d1-a4 ; une lettre vers la gauche
         movem.l d1-a4,$60(a6)
         movem.l $98(a6),d1-d2
         movem.l d1-d2,$90(a6)
         adda.l #$98,a6

         move.l  (a5)+,(a6)+   ; mettre le nouveau caractere
         move.l  (a5)+,(a6)+   ; en bout de ligne

         dbra    d0,scrolh4
         rts

;cette routine est appelee lorsque l'on passe au caractere suivant
;-----------------------------------------------------------------
masque:movem.l d0-d6/a0-a2,-(sp)
       move.l  mem1,d4       ; adresse du 1er caractere
       move.l  mem2,d5       ; adresse du 2me caractere
masq1: moveq   #15,d0        ; hauteur des lettres
       move.l  d5,a1         ; 2eme caractere
       movea.l #st1,a0       ; buffer de lettres
masq2: move.l  0(a1),(a0)+   ; recopier la 2eme lettres entierement
       move.l  4(a1),(a0)+   ; dans st1
       adda.l  #160,a1
       dbra    d0,masq2

       moveq #3,d2           ; 3 buffers a remplir
       moveq #4,d3           ; decalage de 4 pixels
       moveq #12,d6          ; dernier buffer
masq3: movea.l #tab1,a0      ; pointe sur la table des st*
       movea.l 0(a0,d6.w),a0 ; a0 pointe sur l'adresse du st concerne
       movea.l d4,a1         ; a1 pointe sur le 1er sprite_car
       movea.l d5,a2         ; a2               2eme
       moveq   #15,d0        ; hauteur des lettres
masq4:
       move.w 0(a1),d1
       swap d1
       move.w 0(a2),d1
       rol.l d3,d1
       swap d1
       move.w d1,(a0)+

       move.w 2(a1),d1
       swap d1
       move.w 2(a2),d1
       rol.l d3,d1
       swap d1
       move.w d1,(a0)+

       move.w 4(a1),d1
       swap d1
       move.w 4(a2),d1
       rol.l d3,d1
       swap d1
       move.w d1,(a0)+

       move.w 6(a1),d1
       swap d1
       move.w 6(a2),d1
       rol.l d3,d1
       swap d1
       move.w d1,(a0)+

       adda.l #160,a1         ; ligne suivante de la 1ere lettre
       adda.l #160,a2         ; ligne suivante de la 2eme lettre
       dbra d0,masq4
       addq.l   #4,d3           ; decalage
       subq.l   #4,d6           ; passer au buffer st suivant
       subq.l   #1,d2           ; est-ce le dernier buffer
       bne masq3
       movem.l (sp)+,d0-d6/a0-a2
       rts


; affiche le contenu d'un buffer de 160*16 octet a l'ecran
;---------------------------------------------------------
scroh:movea.l adscro,a5        ; adresse de l'affichage
      moveq   #15,d0           ; hauteur de l'affichage-1
scro1:movem.l $00(a6),d1-a4    ; afficher le buffer
      movem.l d1-a4,$00(a5)
      movem.l $30(a6),d1-a4
      movem.l d1-a4,$30(a5)
      movem.l $60(a6),d1-a4
      movem.l d1-a4,$60(a5)
      movem.l $90(a6),d1-d4
      movem.l d1-d4,$90(a5)
      adda.l  #160,a5
      adda.l  #160,a6
      dbra    d0,scro1
      rts

adscro:dc.l $70000+160*73

;Decalage des couleurs
;~~~~~~~~~~~~~~~~~~~~~~


decol tst.w tempo            ; decalage de couleurs 1 fois sur 2
      beq   deco1
      clr.w tempo
      rts
deco1 subq.l #2,ptcol2
      movea.l ptcol2,a0
      cmpa.l #debc-2,a0
      bne deco2
      move.l #finc-2,ptcol2
deco2 move.w #1,tempo
      rts

ptcol2:dc.l debc
tempo:dc.w 1

;gestion du WELCOME !
;~~~~~~~~~~~~~~~~~~~~~

welcome movem.l d0/a0-a2,-(sp)
        movea.l #$77DA0,a0
        movea.l #$77DA0+160*30,a1
        movea.l a0,a2
        moveq  #19,d0
wel1    move.l (a0)+,(a1)+
        move.l (a0)+,(a1)+
        dbra d0,wel1
        movea.l #$77DA0+160,a0
        move.w   #(160*31/8)-1,d0
wel2    move.l  (a0)+,(a2)+
        move.l  (a0)+,(a2)+
        dbra  d0,wel2
        movem.l (sp)+,d0/a0-a2
        rts

;Gestion de la musique
;~~~~~~~~~~~~~~~~~~~~~~

music:
 tst.w  duree
 beq mus1
 subq.w #1,duree
 rts

mus1: movem.l d0/a0,-(sp)
 add.l #14,muspt
 move.l muspt,a0
 cmp.w #$FFFF,(a0)
 beq mus3
mus0:
 move.w (a0)+,duree
 move.l a0,muspt

      move.w #13,d0
mus2: move.b d0,$FF8800
      move.b (a0)+,$FF8802
music1 dbra d0,mus2
      movem.l (sp)+,d0/a0
       rts
mus3: move.l #$60000,muspt
      clr.w duree
      movem.l (sp)+,d0/a0
      rts

muspt:dc.l $60000
duree:dc.w 0

 data
nbligne:dc.b 2,38,1

adligne:dc.l $50000+78*160
adligh:dc.l $703E8             ; adresse du haut de Metal68
adligb:dc.l $725A8             ; adresse du bas de Metal68
stock:dc.l 0                   ; stockage du pointeur sur nbligne
stock1:dc.l 0                  ; stockage du pointeur sur col
adscreen: dc.l $70000          ; adresse physique de l'ecran
mouse:dc.b $12,$00             ; commande pour inhiber la souris

cmpt_let: dc.w 0000
branch:dc.w 0000

mem1:dc.l 00000
mem2:dc.l 00000
tab1:dc.l st1
     dc.l st2
     dc.l st3
     dc.l st4

adresse:dc.l ad4
        dc.l ad1
        dc.l ad2
        dc.l ad3

        
couleur:dc.w $000,$613,$557,$446,$335,$224   ; couleurs de la palette
        dc.w $111,$222,$333,$444,$555,$666   ; normale
        dc.w $777,$447,$233,$777


; couleurs de la palette 0 pour les interruptions

col:dc.w $002,$003,$004,$005,$006,$007
    dc.w $002,$003,$004,$005,$006,$007
    dc.w $002,$003,$004,$005,$006,$007
    dc.w $002,$003,$004,$005,$006,$007
    dc.w $002,$003,$004,$005,$006,$007

;couleur de la bande texte
;~~~~~~~~~~~~~~~~~~~~~~~~~~

col1:dc.w $000,$067,$007,$715,$777,$777,$070,$222
     dc.w $333,$444,$555,$666,$777,$703,$337,$777

; Couleurs scrollees
;~~~~~~~~~~~~~~~~~~~~

debc:dc.w $000,$033,$044,$055,$066,$077,$066,$055,$044,$033 ;bl.vert
     dc.w $000,$031,$042,$053,$064,$075,$064,$053,$042,$031
     dc.w $000,$030,$040,$050,$060,$070,$060,$050,$040,$030 ;vert
     dc.w $000,$732,$742,$752,$762,$772,$762,$752,$742,$732 ;orange
     dc.w $000,$301,$402,$503,$604,$705,$604,$503,$402,$301 ;rose
     dc.w $000,$300,$400,$500,$600,$700,$600,$500,$400,$300 ;rouge
     dc.w $000,$730,$740,$750,$760,$770,$760,$750,$740,$730 ;orange
     dc.w $000,$303,$404,$505,$606,$707,$606,$505,$404,$303 ;violet
     dc.w $000,$333,$444,$555,$666,$777,$666,$555,$444,$333 ;gris cl
     dc.w $000,$003,$004,$005,$006,$007,$006,$005,$004,$003 ;bleu
     dc.w $000,$337,$447,$557,$667,$777,$667,$557,$447,$337 ;bl.blc
     dc.w $000,$217,$227,$237,$247,$257,$247,$237,$227,$217 ;bl.clair
     dc.w $000,$124,$135,$146,$157,$167,$157,$146,$135,$124 ;bleu ciel
     dc.w $000,$113,$224,$335,$446,$557,$446,$335,$224,$113 ;bleu fonc
     dc.w $000,$223,$334,$445,$556,$667,$556,$445,$334,$223 ;gris bleu
     dc.w $000,$333,$444,$555,$666,$777,$666,$555,$444,$333 ;gris
     dc.w $000,$030,$040,$050,$060,$070,$060,$050,$040,$030 ;vert
     dc.w $000,$330,$440,$550,$660,$770,$660,$550,$440,$330 ;jaune vert
     dc.w $000,$730,$740,$750,$760,$770,$760,$750,$740,$730 ;orange
     dc.w $000,$300,$400,$500,$600,$700,$600,$500,$400,$300 ;rouge
     dc.w $000,$504,$604,$705,$706,$707,$706,$705,$604,$504 ;viol.roug
     dc.w $000,$305,$406,$507,$607,$707,$607,$507,$406,$305 ;bl.violet
     dc.w $000,$003,$004,$005,$006,$007,$006,$005,$004,$003 ;bleu
finc:dc.w $000

colext:  dc.w $000,$410,$510,$620,$731,$742,$753,$764
         dc.w $775,$113,$224,$335,$446,$557,$667,$777
 
lettres:dc.l $50000+00  ; A              table d'adresses
        dc.l $50000+08  ; B              de location des
        dc.l $50000+16  ; C              differentes lettres
        dc.l $50000+24  ; D
        dc.l $50000+32  ; E
        dc.l $50000+40  ; F
        dc.l $50000+48  ; G
        dc.l $50000+56  ; H
        dc.l $50000+64  ; I
        dc.l $50000+72  ; J
        dc.l $50000+80  ; K
        dc.l $50000+88  ; L
        dc.l $50000+96  ; M
        dc.l $50000+104 ; N
        dc.l $50000+112 ; O
        dc.l $50000+120 ; P
        dc.l $50000+128 ; Q
        dc.l $50000+136 ; R
        dc.l $50000+144 ; S
        dc.l $50000+152 ; T
        dc.l $50A00+00  ; U
        dc.l $50A00+08  ; V
        dc.l $50A00+16  ; W
        dc.l $50A00+24  ; X
        dc.l $50A00+32  ; Y
        dc.l $50A00+40  ; Z
        dc.l $50A00+48  ;
        dc.l $50A00+56  ; .
        dc.l $50A00+64  ; ?
        dc.l $50A00+72  ; '
        dc.l $50A00+80  ; 0
        dc.l $50A00+88  ; 1
        dc.l $50A00+96  ; 2
        dc.l $50A00+104 ; 3
        dc.l $50A00+112 ; 4
        dc.l $50A00+120 ; 5
        dc.l $50A00+128 ; 6
        dc.l $50A00+136 ; 7
        dc.l $50A00+144 ; 8
        dc.l $50A00+152 ; 9
        dc.l $51400+00  ; ,
        dc.l $51400+08  ; (
        dc.l $51400+16  ; )
        dc.l $51400+24  ; -
        dc.l $51400+32  ; :
        dc.l $51400+40  ; ?
        dc.l $51400+48  ; m
        dc.l $51400+56  ; e
        dc.l $51400+64  ; t
        dc.l $51400+72  ; al
        dc.l $51400+80  ; 68

;les codes suivants sont dans l'ordre ASCII mais les nombres
;correspondent a la place qu'occupent les sprites en memoire
;par exemple : le A est le 1er sprite donc il porte le no 0, mais dans
;la table ASCII il occupe la 34e place apres l'ESP

codage: dc.b 26,28               ; code de ESP et !
        dc.b 46,47,48,49,50      ; code de "#$%& equivalent a Metal68
        dc.b 29,41,42            ; code de ' ( )
        dc.b 26,26               ; non definiees
        dc.b 40,43               ; code de , -
        dc.b 27                  ; code de .
        dc.b 26                  ; non definie
        dc.b 30,31,32,33,34,35,36,37,38,39 ; code des chiffres 0 a 9
        dc.b 44                  ; code de :
        dc.b 26,26,26,26         ; non definiees
        dc.b 45,26               ; ? et non def
;34e place:
        dc.b 0,1,2,3,4,5,6,7,8,9,10,11,12            ; code des
        dc.b 13,14,15,16,17,18,19,20,21,22,23,24,25  ; lettres
        dc.b 51                  ; fin de chaine

message:dc.b '       "#$%&'
        dc.b " EST HEUREUX DE VOUS PRESENTER UNE PREVERSION"
        DC.B " DE -BLUE METAL DEMO-          "
        DC.B "JE CHERCHE QUELQU'UN QUI SAURAIT CREER ET"
        DC.B " PROGRAMMER UNE MUSIQUE D'ENFER QUI ACCOMPAGNERAIT"
        DC.B " CETTE DEMO ( OU PLUSIEURS ) SANS QU'ELLE SOIT DIGITALISEE"
        DC.B " CAR CA PRENDRAIT TROP DE PLACE ... "
        DC.B "LES DESSINS ONT ETE REALISES AVEC NEOCHROME"
        DC.B " ET LA PROGRAMMATION AVEC PROFIMAT. "
        DC.B "CETTE DEMO A VU LE JOUR GRACE AUX SUPERBES DEMOS DE TEX"
        DC.B " QUI M'ONT DONNE L'ENVIE DE FAIRE LA MIENNE ! "
        DC.B " J'AI DONC COMMENCE PAR APPRENDRE L'ASSEMBLEUR 68000 "
        DC.B "PUIS LA GESTION DES INTERRUPTIONS ... MAIS MAINTENANT"
        DC.B " IL FAUT DE LA MUSIQUE !  ALORS SI VOUS CONNAISSEZ, "
        DC.B "N'HESITEZ PAS ET REMONTEZ LA CHAINE JUSQU'A MOI      "
        DC.B "         JE SALUE TOUS LES PIRATES DE BORDEAUX "
        DC.B "( ET PLUS PARTICULIEREMENT KCOLLOCK ) ... PUIS LES AUTRES"

        DC.B " EN COMMENCANT PAR ORDRE ALPHABETIQUE : "
        DC.B " 42-CREW      "
        DC.B " A-HA      "
        DC.B " ALYSSA      "
        DC.B " BOSS      "
        DC.B " CAT'S CLUB      "
        DC.B " CSS      "
        DC.B " DMA      "
        DC.B " MMC      "
        DC.B " RCAP     "
        DC.B " STCS     "
        DC.B " TEX ( THE EXCEPTIONS )      "
        DC.B " THE LORD      "
        DC.B " TNT      "
        DC.B " TSUNOO      "
        dc.b "    ["          ; fin de chaine

 end

 