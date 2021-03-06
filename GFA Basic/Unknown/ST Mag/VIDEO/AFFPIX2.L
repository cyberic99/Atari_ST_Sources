
;********************************
;*   afficher une image video   *
;* mode 320 x 200 => 8 couleurs *
;*    code: (c) rafale 1995     *
;*  version RAM: 384/420 x 256  *
;********************************

;  r�cup�ration des variables
; ----------------------------

   ;adresse de base du buffer
        move.l 4(SP),A5

   ;initialisation du param�tre ligne
        clr.l  D4
        move.w 8(SP),D4

   ;initialisation info couleur
        move.l #0,A6
        move.w 10(SP),A6


 ;initialisation compteurs ligne et pixel
        move #290,D5   ; d�finir le nbre de pixels par ligne
        move   #0,D3   ; initialiser le compteur de pixels

 ;lecture data RAM --> D1 suivant couleur
retour  CMPA #0,A6
        beq rouge
        CMPA #1,A6
        beq vert
        CMPA #2,A6
        beq bleu
        CMPA #3,A6
        beq bleu   ;3=gris:on affiche la composante B, ce qui revient
                   ;au meme qu'afficher R ou V.
        bra mix    ;si diff�rent de R, V, B ou Gris, alors mixage

ROUGE   ADD    #2,A5
        MOVE.B (A5),D1
        add    #1,A5
        bra    affpix

VERT    ADD    #1,A5
        move.b (A5),D1
        add    #2,A5
        bra    affpix

BLEU    MOVE.B (A5),D1
        add    #3,A5
        bra    affpix

MIX     clr.l  D1
        clr.l  D2
        move.b (A5),D1
        add    #1,A5
        move.b (A5),D2
        add.w  D2,D1
        add    #1,A5
        move.b (A5),D2
        add.w  D2,D1
        add    #1,A5
        divu   #3,D1

 ;affichage du pixel en huit niveaux � l'�cran
affpix  lsr     #5,D1
        andi.w  #7,D1
        dc.w    $a000
        movea.l 8(a0),A3   ;recherche des pointeurs
        movea.l 12(a0),A4  ;sous GEM pour affichage
        move.w  D3,(A4)
        move.w  D4,2(A4)
        move.w  D1,(A3)
        dc.w    $a001      ;appel de la procedure "aff. pixel"

 ;inc. compteur pixel + comparer avec valeur finale
        add    #1,D3
        cmp.w  D5,D3
        bne retour    ;si pas fini, aff. pixel suivant,

 ;retour au PRG
        rts  ; good bye !
        end

 