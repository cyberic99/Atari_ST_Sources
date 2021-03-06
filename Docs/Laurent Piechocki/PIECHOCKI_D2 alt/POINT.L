
               TEXT

               INCLUDE       "LINEQU.L"
               INCLUDE       "INIT_TOS.L"
               INCLUDE       "MACROS.L"

               GETREZ
               tst           d0
               beq           OK
               PRINTLINE     MOYENNE
               WAIT
               TERM

OK             SETBLOCK

               DC.W          $A000

               move.l        #CONTROL,ticontrol(a0)
               move.l        #INTIN,tiintin(a0)
               move.l        #PTSIN,tiptsin(a0)
               move.l        #INTOUT,tiintout(a0)
               move.l        #PTSOUT,tiptsout(a0)

               DC.W          $A00A  ;HIDE

               PRINTLINE     MESSAGE
               WAIT
               CCONOUT       #27
               CCONOUT       #'E'

POINT          MACRO         $\1,$\2,$\3
               move          \1,ptsin
               move          \2,ptsin+2
               move          \3,intin
               DC.W          $A001
               ENDM

               move          #319,d5
               move          #1,d0
               PALETTE       NOUVEAU

LOOP           move          #199,d6
BOUCLE         POINT         d5,d6,d0
ENCORE         RANDOM
               and.l         #15,d0
               tst           d0
               beq           ENCORE
               dbf           d6,BOUCLE
               dbf           d5,LOOP

ICI            move          #14,d6
               lea           VECTEUR,a6

CHANGE         move.l        (a6)+,-(sp)
               move          #6,-(sp)
               trap          #14
               addq.l        #6,sp
               INKEY
               tst           d0
               bne           RETOUR
               dbf           d6,CHANGE
               jmp           ICI

               WAIT

RETOUR         CCONOUT       #27
               CCONOUT       #'E'

               PALETTE       ANCIEN

               TERM

               DATA

NOUVEAU        DC.W          $000,$027,$037,$027,$017,$016,$006,$015
               DC.W          $014,$036,$025,$005,$004,$014,$007,$003

UN             DC.W          $000,$007,$027,$037,$027,$017,$016,$006
               DC.W          $014,$015,$036,$025,$005,$004,$014,$007

DEUX           DC.W          $000,$003,$007,$027,$037,$027,$017,$016
               DC.W          $006,$015,$014,$036,$025,$005,$004,$014

TROIS          DC.W          $000,$007,$003,$007,$027,$037,$027,$017
               DC.W          $016,$006,$015,$014,$036,$025,$005,$004

QUATRE         DC.W          $000,$014,$007,$003,$007,$027,$037,$027
               DC.W          $017,$016,$006,$015,$014,$036,$025,$005

CINQ           DC.W          $000,$004,$014,$007,$003,$007,$027,$037
               DC.W          $027,$017,$016,$006,$015,$014,$036,$025

SIX            DC.W          $000,$005,$004,$014,$007,$003,$007,$027
               DC.W          $037,$027,$017,$016,$006,$015,$014,$036


SEPT           DC.W          $000,$025,$005,$004,$014,$007,$003,$014
               DC.W          $007,$027,$037,$027,$017,$016,$006,$015

HUIT           DC.W          $000,$036,$025,$005,$004,$014,$007,$003
               DC.W          $014,$007,$027,$037,$027,$017,$016,$006

NEUF           DC.W          $000,$015,$036,$025,$005,$004,$014,$007
               DC.W          $003,$014,$007,$027,$037,$027,$017,$016

DIX            DC.W          $000,$006,$015,$036,$025,$005,$004,$014
               DC.W          $07,$003,$014,$007,$027,$037,$027,$017

ONZE           DC.W          $000,$016,$006,$015,$036,$025,$005,$004
               DC.W          $014,$007,$003,$014,$007,$027,$037,$027

DOUZE          DC.W          $000,$017,$016,$006,$015,$036,$025,$005
               DC.W          $004,$014,$007,$003,$014,$007,$027,$037

TREIZE         DC.W          $000,$027,$017,$016,$006,$015,$036,$025
               DC.W          $005,$004,$014,$007,$003,$014,$007,$027

QUATORZE       DC.W          $000,$037,$027,$017,$016,$006,$015,$036
               DC.W          $025,$005,$004,$014,$007,$003,$014,$007


VECTEUR        DC.L          NOUVEAU,UN,DEUX,TROIS,QUATRE,CINQ,SIX,SEPT
               DC.L          HUIT,NEUF,DIX,ONZE,DOUZE,TREIZE,QUATORZE


ANCIEN         DC.W          $777,$500,$070,$000,$000,$000,$000,$000
               DC.W          $000,$000,$000,$000,$000,$000,$000,$000

MESSAGE        DC.B          27,'E',174,' Image brouill�e ',175,' :avec la'

               DC.B          ' fonction',13,10,'$A001 et RANDOM pour les '
               DC.B          'couleurs ...',13,10,13,10,'(Une touche pour '
               DC.B          'Quitter)',0

MOYENNE        DC.B        27,'E','ATTENTION, Ce programme ne marche '
               DC.B        'qu',39,'en BASSE RESOLUTION !',13,10,'Il faut '
               DC.B        'changer la r�solution grace au BUREAU GEM...',7,0


               BSS

               INCLUDE       "TABLEAU.L"

               END


 