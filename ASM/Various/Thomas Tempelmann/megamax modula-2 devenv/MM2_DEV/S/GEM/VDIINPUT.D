DEFINITION MODULE VDIInputs;


(*  Megamax-Modula 2 GEM-Library :  Die VDI Eingabefunktionen
 *
 *  Autor: Manuel Chakravarty           Erstellt :  04.11.87
 *
 *  Version 2.2         V#0006
 *)

FROM    SYSTEM     IMPORT WORD, LONGWORD;
FROM    MOSGlobals IMPORT MemArea;
FROM    GrafBase   IMPORT Point, Rectangle, PtrMouseFormDef;
FROM    GEMGlobals IMPORT GemChar, MButtonSet, SpecialKeySet;
FROM    GEMEnv     IMPORT DeviceHandle;


PROCEDURE RequestLoc (    handle : DeviceHandle;
                          start  : Point;
                      VAR termBut: CHAR;
                      VAR loc    : Point);

        (*  Der Mauszeiger wird auf eine bestimmte Position gesetzt,
         *  danach wird gewartet, bis eine Taste oder ein Mausknopf
         *  gedr�ckt wird.
         *
         *  'start'     -- An diese Stelle wird der Mauszeiger gesetzt.
         *  'termbut'   -- Code der Taste, die zum Abbruch f�hrte.
         *                 ( = 32/33: linke bzw. rechte Maustaste)
         *
         *  ACHTUNG: Die Routine funktioniert nur bei physikalisch
         *           ge�ffneten Arbeitsstationen (Devices), jedoch
         *           nicht bei virtuellen (wie dem Bildschirm)!
         *)

PROCEDURE TestLoc (    handle              : DeviceHandle;
                       start               : Point;
                   VAR termbut             : CHAR;
                   VAR keyPress, koorChange: BOOLEAN;
                   VAR loc                 : Point);

        (*  Entspricht 'RequestLoc' nur wird nicht gewartet, bis eine Taste
         *  gedr�ckt ist, sondern gleich zur�ckgekehrt.
         *  Ist 'keyPress = TRUE', so wurde eine Taste bet�tigt.
         *  Ist 'koorChange = TRUE', so wurde der Mauszeiger bewegt.
         *
         *  ACHTUNG: Die Routine funktioniert nur bei physikalisch
         *           ge�ffneten Arbeitsstationen (Devices), jedoch
         *           nicht bei virtuellen (wie dem Bildschirm)!
         *)


(*      Die folgenden acht Routinen arbeiten in der aktuellen TOS-Version
 *      nicht. Evtl. mit GDOS.
 *)

PROCEDURE RequestValue (    handle : DeviceHandle;
                            start  : CARDINAL;
                        VAR termBut: CHAR;
                        VAR value  : CARDINAL);

        (*  Der Startwert 'start' kann vom Anwender solange mit den
         *  Cursortasten ver�ndert werden, bis er eine andere Taste
         *  dr�ckt.
         *  'value' liefert den neuen Wert und 'termBut' die Taste,
         *  mit der abgebrochen wurde.
         *  Wert liegt zwischen 1 und 100
         *)

TYPE    TValState       = (nothingHappened, valueChanged, keyPressed);

PROCEDURE TestValue (    handle : DeviceHandle;
                         start  : CARDINAL;
                     VAR termbut: CHAR;
                     VAR status : TValState;
                     VAR value  : CARDINAL);

        (*  Entspricht 'RequestValue', nur wird sofort zur�ckgekehrt und
         *  'status' enth�lt
         *
         *    'nothingHappened', falls keine Benutzeraktion erfolgte,
         *    'valueChanged'   , falls der Wert ge�ndert wurde,
         *    'keyPressed'     , falls eine Taste gedr�ckt wurde.
         *)

PROCEDURE RequestChoice (    handle: DeviceHandle;
                             start : CARDINAL;
                         VAR choice: CARDINAL);

        (*  Es wird gewartet bis eine Taste gedr�ckt wird.
         *  War es eine Funktionstaste, so wird deren Nummer in 'choice'
         *  geliefert, sonst der in 'start' �bergebenen Wert (1 - 10).
         *)

PROCEDURE TestChoice (    handle  : DeviceHandle;
                      VAR keyPress: BOOLEAN;
                      VAR choice  : CARDINAL);

        (*  Wie 'TestChoice', nur wird nicht gewartet. Und es ist 'keyPress
         *  = TRUE', falls eine Funktionstaste bet�tigt wurde.
         *)

PROCEDURE RequestString (    handle : DeviceHandle;
                         VAR str    : ARRAY OF CHAR;
                             echo   : BOOLEAN;
                             echoLoc: Point);

        (*  Wartet bis ein String vollst�ndig, durch <Return> abgeschlossen,
         *  eingegeben wurde. Falls 'echo = TRUE' ist, wird die Eingabe ab
         *  der Position 'echoLoc' auf dem Bildschirm ausgegeben.
         *
         *  ACHTUNG: Diese Routine ist in der aktuellen Version nicht impl.
         *)

PROCEDURE TestString (    handle : DeviceHandle;
                      VAR str    : ARRAY OF CHAR;
                          echo   : BOOLEAN;
                          echoLoc: Point;
                      VAR success: BOOLEAN);

        (*  Entspricht 'RequestString' nur wird nicht auf ein <Return> ge-
         *  wartet. Ist 'success = TRUE', so wurde mindestens ein Zeichen
         *  gelesen.
         *
         *  ACHTUNG: Diese Routine ist in der aktuellen Version nicht impl.
         *)

PROCEDURE RStringCode (    handle : DeviceHandle;
                       VAR str    : ARRAY OF GemChar;
                           echo   : BOOLEAN;
                           echoLoc: Point);

        (*  Wie 'RequestString', nur wird sowohl ASCII als auch IBM-Scancode
         *  geliefert.
         *
         *  ACHTUNG: Diese Routine ist in der aktuellen Version nicht impl.
         *)

PROCEDURE TStringCode (    handle : DeviceHandle;
                       VAR str    : ARRAY OF GemChar;
                           echo   : BOOLEAN;
                           echoLoc: Point;
                       VAR success: BOOLEAN);

        (*  Wie 'TestString', nur wird sowohl ASCII als auch IBM-Scancode
         *  geliefert.
         *
         *  ACHTUNG: Diese Routine ist in der aktuellen Version nicht impl.
         *)


PROCEDURE SetMouseForm (handle : DeviceHandle;
                        newForm: PtrMouseFormDef);

        (*  Die durch 'newForm' spezifierte Mausform wird durch diese
         *  Routine gesetzt.
         *)

PROCEDURE ShowCursor (handle: DeviceHandle; force: BOOLEAN);

        (*  Der Grafikcursor (Mauszeiger) wird sichtbar gemacht.
         *  Da das VDI mitz�hlt, wie oft der Zeiger versteckt wurde, mu�
         *  er auch entsprechend oft sichtbar gemacht werden. Dies kann
         *  umgangen werden, indem man f�r 'force' den Wert 'TRUE' an-
         *  gibt. Daraufhin wird der Cursor auf alle F�lle angezeigt.
         *
         *  ACHTUNG: Diese Funktion darf nur bei physikalisch ge�ffneten
         *           Arbeitstationen (Devices) verwendet werden. Beim
         *           Bildschirm (eine virtuelle Arbeitsstation) m�ssen
         *           Sie stattdessen die Funktion "GrafMouse" aus
         *           AESGraphics verwenden!
         *)

PROCEDURE HideCursor (handle: DeviceHandle);

        (*  Der Grafikcursor wird versteckt (unsichtbar).
         *  Siehe auch 'ShowCursor'.
         *
         *  ACHTUNG: Diese Funktion darf nur bei physikalisch ge�ffneten
         *           Arbeitstationen (Devices) verwendet werden. Beim
         *           Bildschirm (eine virtuelle Arbeitsstation) m�ssen
         *           Sie stattdessen die Funktion "GrafMouse" aus
         *           AESGraphics verwenden!
         *)

PROCEDURE GetMouseState (    handle  : DeviceHandle;
                         VAR position: Point;
                         VAR buts    : MButtonSet);

        (*  Es wird die aktuelle Position des Mauszeigers ('position')
         *  und der Status (gedr�ckt oder nicht) der Mauskn�pfe ('buts')
         *  erfragt.
         *)

PROCEDURE KeyboardState (handle: DeviceHandle): SpecialKeySet;

        (*  Es wird ermittelt welche Sondertasten (Alternate, Control,
         *  linke und rechte Shifttaste) gedr�ckt sind.
         *)
         
         
(*      Mit Hilfe der folgenden Routinen k�nnen sogenannte 'Softvektoren',
 *      dies sind datentechnisch Prozedurvariablen, 'umgebogen' werden.
 *      Im Klartext bedeutet dies, da� f�r den urspr�nglichen Wert der Pro-
 *      zedurvariable ein neuer eingesetzt wird. Diese neue Prozedur hat
 *      zwei M�glichkeiten, zum einen kann sie die alte Prozedur voll-
 *      st�ndig ersetzen. Andererseits kann sie die zu verarbeitenden Daten
 *      lediglich modifizieren, kontrollieren oder protokolieren und da-
 *      nach die urspr�ngliche Routine aufrufen.
 *      Dies Prinzip ist nun folgenderma�en implementiert worden. Zu jedem
 *      der Vektoren (Prozedurvariablen) wird eine Liste verwaltet. In diese
 *      Liste k�nnen Prozeduren mit einer bestimmten Schnittstelle (Para-
 *      meterliste) eingetragen und nat�rlich auch wieder gel�scht werden.
 *      Wird nun eine dieser Prozedurvariablen benutzt, so wird zuerst die
 *      zuletzt installierte Routine ausgef�hrt und falls diese es w�nscht
 *      eine weitere. Dies setzt sich durch die gesamte Liste fort. Wird
 *      nun das Listenende erreicht, so wird die, vor dem Aktivieren dieses
 *      Moduls aktuelle Prozedur ausgef�hrt.
 *      Jede installierte Routine liefert als Ergebnis einen BOOLEAN-Wert.
 *      Ist dieser gleich 'TRUE', so hei�t dies, da� mit der Ausf�hrung
 *      der in der Liste enthaltenen Prozeduren fortgefahren werden soll.
 *      Sonst wird die Kette unterbrochen.
 *
 *      Zum Installieren einer Prozedur mu� ein 'Carrier' (Tr�ger) �bergeben
 *      werden, dieser dient erstens als Kennung (handle) und zweitens wird
 *      er zur zum Aufbau der Listenstruktur ben�tigt. Daher ist es von ele-
 *      mentarer Wichtigkeit, da� der Carrier global definiert wird und bis
 *      zum Entfernen der Routine aus der Liste weder anderweitig verwendet,
 *      noch irgendwie freigegeben wird. Weiter mu� ein Arbeitsbereich (work-
 *      space) f�r die Prozedur angegeben werden, dieser wird w�hrend der Ab-
 *      arbeitung der Routine als Stackbereich verwendet, es mu� also unbe-
 *      dingt sichergestellt werden, da� dieser Speicherbereich erstens zur
 *      Verf�gung steht, zweitens nicht schon benutzt wird und eine aus-
 *      reichende Gr��e besitzt. In der Regel reichen wohl 2 kByte aus.
 *
 *      Achtung: Die Aufrufe der Vektoren geschehen von Interruptroutinen aus.
 *               Da gro�e Teile des Betriebssystem nicht oder nur bedingt re-
 *               entrantf�hig sind, das hei�t es darf w�hrend eines Betriebs-
 *               systemaufrufes noch ein weiterer ausgef�hrt werden, ist es
 *               zu empfehlen, solche Aufrufe (dazu geh�hrt z.B. auch 'Write')
 *               nicht in einer Vektorroutine zu t�tigen. Es k�nnten v�llig
 *               unvorhersehbare Systemabst�rze herbeigef�hrt werden!
 *)


TYPE    TimerVecCarrier          = ARRAY[0..11] OF WORD;
        TimerVecProc             = PROCEDURE (): BOOLEAN;

PROCEDURE InstallTimerProc (VAR hdl      : TimerVecCarrier;
                                newProc  : TimerVecProc;
                                wsp      : MemArea;
                            VAR deltaTime: CARDINAL);
                            
        (*  Der Timervektor stellt eine Prozedurvariable dar, die in bestim-
         *  mten Zeitabst�nden immer wieder aufgerufen wird. Er ist also
         *  f�r das Abarbeiten zyklisch wiederkehrender Aufgaben pr�desti-
         *  niert.
         *  'hdl'       --  der Carrier f�r die hiermit angemeldete Prozedur
         *  'newProc'   --  beschreibt den von ihr zu benutzenden Stack-
         *                  bereich.
         *  'wsp'       --  ebenfalls
         *  'deltaTime' --  Der Zeitabstand zwischen zwei Aufrufen (in Milli-
         *                  sekunden).
         *)

PROCEDURE RemoveTimerProc (VAR hdl: TimerVecCarrier);

        (*  Meldet die durch 'hdl' beschriebene Prozedur wieder ab, das
         *  hei�t sie wird aus der Liste der aufzurufenden Prozeduren
         *  gestrichen.
         *)


TYPE    ButChgVecCarrier        = ARRAY[0..9] OF WORD;
        ButChgVecProc           = PROCEDURE (VAR (* pressed: *) MButtonSet)
                                            : BOOLEAN;
        
PROCEDURE InstallButChgProc (VAR hdl: ButChgVecCarrier;
                             newProc: ButChgVecProc;
                             wsp    : MemArea);
                             
        (*  Der Button-Change-Vektor wird immer aufgerufen, wenn der Status
         *  der Maustasten ge�ndert wurde. Also eine Maustaste gedr�ckt oder
         *  losgelassen wurde. Jeder installierten Routine werden die zur
         *  Zeit gedr�ckten Maustasten (in 'pressed') �bergeben. Dieser
         *  Wert kann ge�ndert werden und es wird die ge�nderte Version dann
         *  auch vom Betriebssystem �bernommen.
         *  'hdl' enth�lt den Carrier, 'newProc' die neue Prozedur und 'wsp'
         *  ihren Stackbereich.
         *)

PROCEDURE RemoveButChgProc (VAR hdl: ButChgVecCarrier);

        (*  Meldet die mit 'InstallButChgProc' installierte Routine
         *  wieder ab.
         *)


TYPE    MsMoveVecCarrier        = ARRAY[0..9] OF WORD;
        MsMoveVecProc           = PROCEDURE (VAR (*loc:*) Point)
                                            : BOOLEAN;
        
PROCEDURE InstallMsMoveProc (VAR hdl    : MsMoveVecCarrier;
                                 newProc: MsMoveVecProc;
                                 wsp    : MemArea);

        (*  Der Mouse-Movement-Vektor wird bei jeder Mausbewegung ange-
         *  sprungen. Dabei wird der Routine (in 'loc') die aktuelle
         *  Mausposition �bergegeben, diese kann von der Routine auch
         *  ver�ndert werden. Durch Vertauschen der Koordinaten kann man
         *  z.B die beiden Bewegungsrichtungen der Maus vertauschen.
         *  Mit etwas mehr Aufwand k�nnen die Bewegungen auch gespie-
         *  gelt werden oder es wird einfach ein Rahmen vorgegeben,
         *  der von der Maus nicht verlassen werden darf.
         *  Es ist 'hdl' der Carrier und 'wsp' der Stackbereich f�r die
         *  zu installierende Routine 'newProc'.
         *)
                          
PROCEDURE RemoveMsMoveProc (VAR hdl: MsMoveVecCarrier);

        (*  Es wird 'hdl' abgemeldet.
         *)
         

TYPE    CurChgVecCarrier        = ARRAY[0..9] OF WORD;
        CurChgVecProc           = PROCEDURE (VAR (*loc:*) Point)
                                            : BOOLEAN;
        
PROCEDURE InstallCurChgProc (VAR hdl    : CurChgVecCarrier;
                                 newProc: CurChgVecProc;
                                 wsp    : MemArea);
                             
        (*  Der Cursor-Change-Vektor wird bei jeder Positions�nderung
         *  des Mauszeigers aufgerufen. Der aufgerufenen Prozedur wird
         *  (in 'loc') die neue Mauszeigerposition �bergeben.
         *  Dabei ist 'hdl' der Carrier und 'wsp' der Stackbereich der
         *  Prozedur 'newProc'.
         *)
                          
PROCEDURE RemoveCurChgProc (VAR hdl: CurChgVecCarrier);

        (*  Es wird eine mit obiger Prozedur angemeldete Routine wieder
         *  abgemeldet.
         *)


END VDIInputs.
