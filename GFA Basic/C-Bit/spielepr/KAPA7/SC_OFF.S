******** Kopieren von n Zeilen eines Lores - Screens *************

;erweitert durch Offset zur n�chsten Zeile
;erm�glicht Vergr��erungseffekte u. Spiegelungen

* In A0 befindet sich die Anfangsadresse Quelle
* In A1 die Anfangsadresse Ziel
* D0 Z�hler f�r die zu �bertragenden Zeilen
* D1 Offset zur n�chsten Zeile f�r Source
* D2 Offset zur n�chsten Zeile f�r Destination




**************** kopieren einer Zeile **************

zeile:

                movem.l (A0)+,D1-D7/A2-A6 ; die ersten 13 Longs lesen (Quelle)
                movem.l D1-D7/A1-A6,(A1) ;  schreiben (Ziel)
                lea     52(A1),A1       ;   Addiert 52 Bytes zu A1 dazu
                movem.l (A0)+,D1-D7/A2-A6 ; nochmal 13 Longs lesen (Quelle)
                movem.l D1-D7/A2-A6,(A1) ;  schreiben (Ziel)
                lea     52(A1),A1
                movem.l (A0)+,D1-D7/A2-A6 ; nochmal 13 longs lesen (Quelle)
                movem.l D1-D7/A2-A6,(A1) ;  schreiben (Ziel)
                lea     52(A1),A1
                move.l  (A0)+,(A1)+     ;   das letzte Long

************  addition des Offsets (Abstand) zu n�chsten Zeile *********

                adda.l  D1,A0           ;addiert Offset Source
                adda.l  D2,A1           ;addiert Offset Destin.

*************************************************************************

                dbra    D0,zeile


*****************************************************




                END
