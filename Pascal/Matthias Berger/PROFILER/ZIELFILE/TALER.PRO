PROGRAM Erbteilung; { 7. Bundeswettbewerb Informatik 1988/1989 }
                    { 1. Runde, Aufgabe 3 ; Autor M. Berger    }
                    {     Bitte Hinweise am Ende beachten !    }
CONST Max_Anzahl_Goldstuecke  = 100;
      Max_Anzahl_Erben        = 10;
      
TYPE  Geldkiste          = ARRAY [1..Max_Anzahl_Goldstuecke] OF
                                 INTEGER;
VAR   Goldstuecke        : Geldkiste;   {  GOLDSTUECKE : 110  }
      Anzahl_Goldstuecke : INTEGER;
                        {  ANZAHL_GOLDSTUECKE : 49  Min 0.  Max 14  }
      Anzahl_Erben       : INTEGER;  {  ANZAHL_ERBEN : 6  Min 2  Max 2  }
      
  PROCEDURE Eingabe;  { 1 }
    BEGIN
      CLRSCR;WRITELN('Erbteilung  (bwINF 7 [88/89];Aufgabe 2)');WRITELN;
      WRITELN;WRITE('  Bitte Anzahl Erben(Erbinnen) eingeben : ');
      REPEAT  { 1 }
        READLN(Anzahl_Erben);
      UNTIL Anzahl_Erben<Max_Anzahl_Erben;
      WRITELN;WRITELN('  Bitte Werte der M�nzen eingeben (Ende mit <RETURN>)');
      Anzahl_Goldstuecke:=0;
      REPEAT  { 14 }
        Anzahl_Goldstuecke:=Anzahl_Goldstuecke+1;
        WRITE('     ->');
        READLN(Goldstuecke[Anzahl_Goldstuecke]);
      UNTIL (Goldstuecke[Anzahl_Goldstuecke]=0) OR 
            (Anzahl_Goldstuecke>Max_Anzahl_Goldstuecke);
      Anzahl_Goldstuecke:=Anzahl_Goldstuecke-1;
      WRITELN;WRITELN;CLRSCR;
    END;
    
  PROCEDURE Aufteilung;  { 1 }
          
    VAR i,u                : INTEGER;  {  I : 42  Min 0.  Max 14  }
                        {  U : 30  Min 0.  Max 102  }
        jeder_erbt         : INTEGER;  {  JEDER_ERBT : 29  Min 51  Max 51  }
        Akt_Erbe           : INTEGER;  {  AKT_ERBE : 6  Min 0.  Max 2  }
        Ergebniss_gefunden : BOOLEAN;  {  ERGEBNISS_GEFUNDEN : 79  }
        HILFSarray         : Geldkiste;  {  HILFSARRAY : 2  }
    
    FUNCTION ermittle_durchschnittl_Erbe : REAL;  { 3 }
      VAR i         : INTEGER;  {  I : 42  Min 1  Max 14  }
          hilfsumme : REAL;  {  HILFSUMME : 48  Min 0.  Max 102  }
      BEGIN
        hilfsumme:=0;
        FOR i:=1 TO Anzahl_Goldstuecke DO  { 39 }
        BEGIN
          hilfsumme:=hilfsumme+Goldstuecke[i];
        END;
        hilfsumme:=hilfsumme/Anzahl_Erben;
        ermittle_durchschnittl_Erbe:=hilfsumme;
      END;
      
    PROCEDURE teste (Uebrige    : Geldkiste;  { 73 }  { Max. Rekursion: 6 }
                        {  UEBRIGE : 254  }
                     Genommene  : Geldkiste;  {  GENOMMENE : 97  }
                     Anz_Genomm : INTEGER;
                        {  ANZ_GENOMM : 99  Min 1  Max 7  }
                     Summe      : INTEGER;  {  SUMME : 112  Min 10  Max 51  }
                     Stelle     : INTEGER);  {  STELLE : 97  Min 1  Max 13  }
     
      VAR  i    : INTEGER;  {  I : 153  Min 2  Max 14  }
           Zahl : INTEGER;  {  ZAHL : 99  Min 3  Max 17  }
      
      PROCEDURE Ausgabe;  { 2 }
        VAR i,u : INTEGER;  {  I : 43  Min 1  Max 14  }
                        {  U : 0.  Min ---  Max ---  }
        BEGIN
          WRITELN('Es erbt Erbe Nr. ',akt_Erbe,' die M�nzen :  ');
          WRITE('  ');
          FOR i:=1 TO Anz_Genomm DO  { 13 }
          BEGIN
            IF i>1 THEN WRITE(',');  { 11 }
            WRITE(Genommene[i]);
          END;
          WRITELN('.  Summe = ',Summe);WRITELN;
          FOR i:=1 TO Anzahl_Goldstuecke DO  { 26 }
            Goldstuecke[i]:=Uebrige[i];
        END;
      
      BEGIN
        Zahl:=Uebrige[Stelle];
        IF NOT(Ergebniss_Gefunden) THEN  { 13 }
        BEGIN
          Summe:=Summe+Zahl;
          IF Summe<=jeder_erbt THEN  { 13 }
          BEGIN
            Uebrige[Stelle]:=0;
            Anz_Genomm:=Anz_Genomm+1;
            Genommene[Anz_Genomm]:=Zahl;
            IF Summe<jeder_erbt THEN  { 11 }
            BEGIN
              FOR i:=Stelle+1 TO Anzahl_Goldstuecke DO  { 71 }
                IF Uebrige[i]>0 THEN  { 71 }
                  teste(Uebrige,Genommene,Anz_Genomm,Summe,i);
            END
            ELSE  { 2 }
            BEGIN
              Ergebniss_gefunden:=TRUE;
              Ausgabe;
            END;
          END;
        END;
      END;
    
    BEGIN
      IF ermittle_durchschnittl_Erbe=INT(ermittle_durchschnittl_Erbe) THEN
                                  { 1 }
      BEGIN
        jeder_erbt:=ROUND(ermittle_durchschnittl_Erbe);
        Akt_Erbe:=0;
        REPEAT  { 2 }
          Akt_Erbe:=Akt_Erbe+1;
          Ergebniss_gefunden:=FALSE;
          u:=0;
          FOR i:=1 TO Anzahl_Goldstuecke DO  { 26 }
            u:=u+Goldstuecke[i];
          IF u>=jeder_erbt THEN  { 2 }
          BEGIN
            i:=0; 
            REPEAT  { 8 }
              i:=i+1;
            UNTIL Goldstuecke[i]>0;
            teste(Goldstuecke,HILFSarray,0,0,i);
          END;
        UNTIL (Ergebniss_gefunden=FALSE) OR (Akt_Erbe=Anzahl_Erben);
        IF Ergebniss_gefunden=FALSE THEN  { 0. }
        BEGIN
          WRITELN;WRITE(' Erbe Nr. ',Akt_Erbe,' w�rde nicht das richtige ');
          WRITE('Erbe erhalten. Es erbt das Kloster. ');
        END;
      END
      ELSE  { 0. }
      BEGIN
        WRITELN;WRITELN(' Eine Aufteilung geht nicht. Das Kloster erbt. ');
      END;
    END;
  
  BEGIN
    Eingabe;
    Aufteilung;
  END.
{
 Problemstellung :
 
 Die Baronin von Birlinghoven hat ihren beiden T�chtern eine Truhe voller
 Goldm�nzen hinterlassen. Ihr Testament bestimmt, da� das Gold einem benach-
 barten Kloster zukommt, falls es den T�chtern nicht gelingt, den Ihnalt der
 Truhe wertm��ig genau in zwei H�lften aufzuteilen. Die Goldm�nzen haben nur
 ganzzahlige Werte.
 Eine Truhe Goldm�nzen mit den Werten 1,9,5,3,8 Taler k�nnten die
 T�chter in die H�lften 1,9,3 Taler und 5,8 Taler teilen.
 Eine Truhe Goldm�nzen mit den Werten 1,9,7,3,8 Taler fiele an das Kloster,
 weil die Aufteilung nicht m�glich ist.
 Schreibe ein Programm, das bei Eingabe einer Folge ganzer Zahlen f�r die in
 der Truhe vorkommenden Werte die Erbteile genau aufz�hlt, andernfalls das 
 Erbe dem Kloster zuspricht, falls eine Aufteilung nicht m�glich ist.
 
 Beispiel :
  
  M�nzwerte : 17,3,7,6,8,10,10,5,5,4,10,9,8
  Erbinnen  : 2
  Ergebnis  : Erbin 1 erbt 51 Taler, n�mlich 17,3,7,6,8,10
                    2      51                10,5,4,10,9,8
                    
 Besonderheiten :
 
  Rekursion
  
}
 
