***************************************************************************
* BASIC-KONVERTER NACH C - Test-Version 2.02 - READ_ME-Datei              *
* (C)-1990/91  CICERO-Software                                            *
*              Ballweilerstra�e 7                                         *
*              6676 Mandelbachtal 4                                       *
*              Tel.06803/2834                                             *
***************************************************************************

Achtung!
Diese Test-Version enth�lt keine Bibliotheken f�r die Feldverwaltung
und nur eingeschr�nkte Bibliotheken der anderen GFA-BASIC-Funktionen.
(z.B. nur Teile der VDI/AES-Funktionen)
Header- und Makefiles sind diesen Einschr�nkungen angepa�t.
Au�erdem kann diese Version von 'B NACH C' nur Listings bis zur Gr��e
von 10 KByte bei einem Konverterdurchlauf bearbeiten.

Erst  die  offizielle  Version  'BASIC Konverter nach C Professional'
kann 98% aller GFA-BASIC-Befehle durch entsprechende Bibliotheksfunk-
tionen umsetzen. Hierzu geliefert wird auch ein  530 Seiten umfassen-
des Handbuch, das wichtige Tips und Tricks zu  GFA-BASIC und  Turbo C
neben  einer  ausf�hrlicher Darstellung der Funktionen (Referenzteil)
und eine Einf�hrung in C beinhaltet.

Die Version  PIONIER  bearbeitet GFA-BASIC zu ca. 50%. Auch zu dieser
Version wird das  530 Seiten starke  Handbuch  incl. dem Referenzteil
geliefert. Die Version PIONIER, die 189.- kostet, bearbeitet  Sourcen
bis zur Gr��e von 20 KByte.


Wenn Sie diese Diskette an die 

Firma CICERO-Software
Ballweilerstra�e 7
6676 Mandelbachtal 4

einsenden und die Versionen  PIONIER oder Professional bestellen, k�n-
nen Sie die in der  TOS  angek�ndigten g�nstigen Programmversionen be-
ziehen.


Wir w�nschen Ihnen viel Freude beim  Konvertieren und viel Erfolg  auf
dem schnellen Weg nach C.

CICERO-Software

M�rz 1991

------------------------------------------------------------------

Wichtige Anmerkungen!!!

1. Fehler in Turbo C

  Aufgrund folgender Fehler in TC 2.0x kann es bei der Konvertierung der
  GFA-BASIC-Source zu Problemen bzw. zu Inkompatibilit�ten kommen:
  
    1. Fehler bei setmatherr: Das Starten von gr��eren Programmen
       (vgl. morphos.lst) ist evnt. nicht m�glich, da TC Vektoren
       in den Data-Bereich das Benutzerprogramms einbindet. Dies
       f�hrt zu Problemen bei Data-Bereichen > 32K. (In Version 2.03
       behoben)
       
    2. Fehler bei SIGNAL  : ON BREAK ist nicht m�glich.  Beim  Konvertieren
       kann nach dem Druck von Control D  keine Taste mehr gedr�ckt werden.
       Bei den Rechnern der TT-Klasse mu� der Konverter sogar ganz die M�g-
       lichkeit,  einen  Break  w�hrend der Konvertierung machen zu k�nnen,
       ausschlie�en.
    
    3. Fehler bei Typkonvertierungen (vor allem bei verschachtelten Makros)
    
    4. Fehler bei Ausgabe von printf("%G",xx).  Flie�kommazahlen werden mit
       vielen  sinnlosen Nullen nach dem  '.' ausgegeben.  Dieses Verhalten
       ist bei  Ausgaben von Strings und bei PRINT USING f�r Fehler verant-
       wortlich.

  Die Firma Borland hat uns zugesichert, da� diese Fehler bald behoben sein
  werden. Bitte wenden Sie sich  direkt  an  Borland  M�nchen, um eine neue
  Version von Turbo C zu erhalten.

----------------------------------------------------------------------------

2. Tips zu Turbo C:

----------------------------------------------------------------------------

Zur problemlosen Konvertierung und Compilierung sollten Sie folgende Com-
pilerschalter in Turbo C setzen:

  -Size optimations
  -Use absolute calls (bei kleineren Programmen nicht notwendig)

manchmal bei sehr gro�en Programmen wegen eines Fehlers in Turbo C 
erforderlich:

  -no string merging

Bei �beraus gro�en Basicprogrammen, die konvertiert wurden (bis ca. 700 K)
hatte Turbo C bisweilen das Problem, da� Stringkonstanten ( z.B. printf()-
Formatstrings nicht korrekt �bergeben wurden,  wobei  sich  herausstellte, 
da� im ausf�hrbaren Programm falsche Pointer gesetzt waren(?). (Vielleicht
arbeitet der Codeerzeuger von Turbo C bei gro�en Data-Bereichen nicht v�l-
lig korrekt).

Stacksize: ca. 4096 - 16384

(Bitte beachten Sie, da� Turbo Debugger nur Stackgr��en in der Zweierpotenz
richtig bearbeiten kann, es ergibt sich sonst  die  nicht sehr aussagekr�f-
tige Fehlermeldung: Sourcefile hat falsches Format.

----------------------------------------------------------------------------

3. Tips zu B NACH C

----------------------------------------------------------------------------

Geschwindigkeitssteigerungen unter Turbo C:


In den meisten F�llen werden die ehem. Basicprogramme schneller - dies vor
allem bei  Rechnungen  im  Byte-Word-Long-Integerbereich oder  bei String-
operationen(Faktoren etwa zwischen 1.4 im Integerbereich bis 20 im String-
bereich).
Langsamer werden dagegen nahezu  alle  Flie�kommaoperationen,  da  Turbo C 
eine 10- , das Basic jedoch nur eine 8-Byte  Flie�kommaarithmetik  verwen-
den. Der Vorteil  der  C-Bibliothek liegt jedoch in der wesentlich h�heren
Genauigkeit.
Kommt es Ihnen auf h�chsten Datendurchsatz Ihres  Rechners an,  so  k�nnen
Sie die Unterst�tzung des Coprozessors durch  Turbo C  ausnutzen.  Hierbei
sind Geschwindigkeitssteigerungen bis zum Faktor 500 gemessen worden.
Immer empfiehlt es sich,  wenn  m�glich,  mit Integervariablen zu program-
mieren.


Programmgr��e - Libraries


Da Turbo C beim Aufruf auch von nur einer Flie�kommafunktion die komplette
Library hinzulinkt, kann viel Code dadurch eingespart werden, wenn Sie auf
Flie�kommaoperationen verzichten k�nnen. In diesem Fall m�ssen sie  die im
Ordner A:\LIBOFLT befindlichen Librarys statt der in A:\LIB sich befinden-
den hinzulinken. Beachten Sie, da� dann jedoch  keine  Flie�kommaoperation
stattfinden darf.


Stringl�ngen


W�hrend GFA-BASIC nur Stringl�ngen bis 32767 Byte  Gr��e  erlaubt,  k�nnen
mehrere Konverterstringroutinen bis zu 64 Kbyte Stringl�ngen verarbeiten.
(vgl. hierzu: B_NACH_C.H oder Referenzliste)


Schnellanzeige


Die Schnellanzeige (BASIC-C-Referenz), die B NACH C direkt nach dem Konver-
tieren generiert, referenziert immer nur die 1. Zeile und hiervon der 1.in
einer Zeile zu wandelnde Ausdruck. Bei Umwandlungen, die f�r  eine  Basic-
zeile mehrere C-Zeilen erforderlich machen (z.B. CASE "a","b","c") wird im
C-Bereich nur die Kovertierung des 1. Ausdrucks  angezeigt. Dies wurde we-
gen der gr��eren �bersichtlichkeit  so implementiert.  (Sind  Sie  an  der
kompletten  �bersetzung interessiert, so lassen  sich Basic- und C- Source
sowieso leicht in einem Texteditor vergleichen). Die mit 'Datei - Gehe zu'
oder Control G anzuspringende bzw. angezeigte Zeilennummer  entspricht  in
der Regel  NICHT!!!  der GFA-BASIC-Source-Zeile,  da  nicht konvertierbare
Zeilen oder Zeilen ohne direkte Referenz im 3. Pass nicht angezeigt werden.

Die Cursorsteuerung der Schnellreferenz ist:

Cursor up         : eine Zeile in Richtung kleinerer Basiczeilen
Cursor down       : eine Zeile in Richtung gr��erer  Basiczeilen
Shift-Cursor up   : eine Seite in Richtung kleinerer Basiczeilen
Shift-Cursor down : eine Seite in Richtung gr��erer  Basiczeilen
Home              : an den Anfang
Shift Home        : ans Ende
CONTRL G          : Gehe zu (Zeile)

Wurde durch CONTRL O oder 'Datei-Lesen' eine Basicdatei eingelesen, so er-
scheint eine ganzseitige  Anzeige,  in der man i.U.z.o.  zeilenweise durch
den Text scrollen kann

Da die Referenzanzeige f�r jede Zeile 8  Byte  Speicherplatz  beansprucht,
kann sie unter dem Men�punkt 'Referenzieren' ganz ausgeschaltet werden- es
wird dann kein Speicher mehr angefordert, im Gegensatz zu dem  Men�eintrag
'Umsetzung anzeigen', bei dem lediglich die Bildschirmanzeige aus- und an-
geschaltet werden kann. Dies empfiehlt sich besonders bei  sehr gro�en An-
wendungen.


Neue Implementationen der Version 2.01/2


Neu ist der Men�eintrag unter der Rubrik 'Konvertieren' 'C++ - Mode'.  Der
Konverter generiert C-Code f�r C++ - Compiler, wenn vor diesem Eintrag ein
Haken ist.
Die Gr��e des freien Speichers l��t sich unter dem Eintrag  'System-Freier
Speicher' erfragen.
Unter Datei-Errorfile ist es m�glich, statt Bildschirmausgaben von Fehler-
meldungen eine Fehlerdatei erstellen zu lassen.  Auch  diese  Ausgaben be-
r�cksichtigen die weiter unten beschriebene  B NACH C  Compileroption '$W'
und die Einstellungen  der Warnungsstufen im Men� 'Parameter �ndern'. Wird
ein Errorfile erstellt, schreibt B NACH C keine Warnungen in die C-Source.
Bitte beachten Sie, da� Fehler (z.B. nicht konvertierte Befehle) von Ihnen
nachtr�glich bearbeitet werden m�ssen (PIONIER-Version).


Dynamische Stringverwaltung (in der Testversion nicht vorhanden!)


Mit Hilfe des Eintrages 'Optionen-Dyn./Stat. Strings' wird  der  Konverter
veranlasst, C-Code f�r statische oder dynamische  Strings  zu  generieren.
Generiert der Konverter Code f�r die dynamische Stringbehandlung, so �ber-
wachen alle Libraryfunktionen eventuelle String�berl�ufe und passen 'auto-
matisch' die Strings wie auch GFA-BASIC an.
Bei statischer Stringverwaltung erhalten  Sie  im Fall  eines  String�ber-
laufs eine Fehlermeldung und m�ssen die erforderlichen Anpassungen wie  im
Handbuch unter 3.5 beschrieben selbst vornehmen.
Vorteil  und Nachteil der jeweiligen Methode  sind im gleichen Kapitel ge-
nannt.
Neu hinzugekommene Funktionen f�r die dynamische Stringverwaltung in C ent-
nehmen Sie der unten angegebenen Referenzliste.


F�r  diese neuen Men�eintr�ge gibt es folgende Schalter f�r die 'APP'-Ver-
sion bzw. f�r das Konfigurationsfile:

                                          DEFAULT (ohne Schalter)
  -f:       Errorfile generieren          kein Errorfile
  -s:       dynamische                    statische Strings
  -m:       Auswahl der Zieldatei         automatische Generierung
            (<src>.LST -> <dest>.C)       der Zieldatei(<src>.LST -> <src>.C)
  -r:       keine Referenzierung          Referenzierung
  -+:       C++ - Mode                    ANSI - Mode

Die Einstellung der Option: 'Schreiben' wird nicht  im  Konfigurationsfile
abgespeichert.

Als neue Compileroption wurde $Wx eingef�hrt, wobei 0<x<7. Die Warnung 'x'
wird nicht mehr angezeigt.
Syntax:

$Wx1,x2,...


Erg�nzung zur Referenzliste


(Stringverwaltung - in der Testversion nicht vorhanden!)

void B_drealloc(str, max_l)

    char **str;          /* Adresse des Pointers auf den BNC-Stringbereich */
    unsigned int;        /* Puffergr��e f�r Reallozierung */

  Funktion:    Reserviert Speicherbereich f�r BNC-Strings der Gr��e
               'max_l' (dynamische BNC-Strings).


char *B_ldrealloc(max_l)

  unsigned int max_l;  /* Puffergr��e f�r Reallozierung */

  Funktion:    Reserviert Speicherbereich f�r BNC-Strings in Unterproze-
               duren der (Puffer-)Gr��e 'max_l'.
  R�ckgabe:    Pointer auf neuen BNC-String (dynamische BNC-Strings).


char *B_ndcpy(src)

  char *src;           /* Pointer des alten Strings */

  Funktion:    Rettet bei 'Call by value' den Inhalt der Stringvariablen
               'src' (dynamische BNC-Strings).
  R�ckgabe:    Pointer auf neuen String


void B_dsfree(str)

  char *src;           /* Pointer auf Stringvariable */

  Funktion:    Gibt tempor�ren Speicherbereich der bei 'Call by value' an-
               gelegten Stringvariablen wieder frei(dynamische BNC-Strings).


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Die erfahrungsgem�� h�ufigsten Ursachen von Inkompatibilit�t:

  - Bereichs�berschreitungen im Integer-Long-Bereich (vgl. 13.4)
    (treten oft bei Multiplikationen zweier Integervariablen auf -
    sind meist durch den Compilerschalter $*% zu beheben, sonst casten!)

  - Falsche Divisionsergebnisse infolge einer Ganzzahldivision des C-
    Compilers, bei der GFA-BASIC noch mit Flie�kommaarithmetik arbeitet
    (treten oft bei Divisionen zweier Integervariablen auf -
    sind meist durch den Compilerschalter $%0 zu beheben, sonst casten!)

  - verlassener Geltungsbereich von lokalen Variablen (vgl. 13.6)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Bitte  achten Sie beim Konvertieren immer auf diese nicht  pauschal  durch
B NACH C bearbeitbaren Inkompatibilit�ten. Bei �ber 80% der Fehler  traten
diese Probleme auf.
