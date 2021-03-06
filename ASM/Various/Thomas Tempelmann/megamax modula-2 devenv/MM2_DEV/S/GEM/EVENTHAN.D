DEFINITION MODULE EventHandler;


(*  Definitionen des 'EventHandler's der Megamax Modula-2 Biblothek
 *
 *  System              : Megamax Modula-2 (MOS 2.0)
 *  Author & Copyright  : Manuel Chakravarty
 *  Vertrieb            : Application Systems Heidelberg
 *  Version             : 2.1      V#0037
 *)
 
(*  Dieses Modul erf�llt zwei Aufgaben, ersten erleichtert es die Program-
 *  mierung von Ereignisschleifen (dies ist die Sorte von Schleife, die
 *  sich typischerweise um ein 'MultiEvent'-Aufruf rankt) und zweitens er-
 *  laubt es das �berwachen des durch 'AESEvent' laufenden Ereignisstroms.
 *
 *  Die Programmierung herk�mmlicher Ereignisschleifen kann man mit der
 *  Prozedur 'HandleEvents' vermeiden. Statt eines Aufrufes von 'MultiEvent'
 *  und den darauf folgenden IF's zum Behandlen der Ereignisse, schreibt man
 *  einfach f�r jedes Ereignis, das man bearbeiten will ein oder mehrere Pro-
 *  zeduren in ein 'ARRAY OF EventProc' und ruft danach 'HandleEvents' auf.
 *  Treten nun ein oder mehrere Ereignisse auf, so werden automatisch alle
 *  Prozeduren, die f�r eines dieser Ereignise angemeldet sind, mit den vom
 *  AES gelieferten Werten aufgerufen. Diese Prozeduren m�ssen nach der Be-
 *  arbeitung des Ereignisses mit einem BOOLEAN-Wert zur�ckkehren. Dabei be-
 *  deutet der Wert 'TRUE', da� das Ereignis auch noch an eventuell vorhandene
 *  andere Prozeduren des gleichen Typs weitergegeben werden soll. Bei der
 *  R�ckgabe von 'FALSE' wird das Ereignis als vollst�ndig bearbeitet ange-
 *  sehen und aus der Menge der aufgetrettenen Ereignisse gestrichen.
 *  Nachdem alle Ereignisse oder Prozeduren bearbeitet sind, kehrt 'Handle
 *  Events' zur�ck. Nun sollte man ermitteln, ob es an der Zeit ist die Er-
 *  eignisschleife zu beenden, falls nicht, wird 'HandleEvents' erneut auf-
 *  gerufen.
 *
 *  Das zweite Feature diese Moduls wird wohl seltener verwendet werden, es
 *  hat aber zum Beispiel in 'TextWindows' Anwendung gefunden.
 *  Es k�nnen, mit 'InstallWatchDog', f�r jedes Ereignis beliebig viele �ber-
 *  wachungsprozeduren angemeldt und diese mit 'DeInstallWatchDog' auch wie-
 *  der abgemeldt werden. Wann immer nun ein Ereignis mit 'HandleEvents',
 *  oder AUCH mit einer der in 'AESEvent' befindlichen Event Manager Rou-
 *  tinen ermittelt wird, wird ZUERST gepr�ft ob f�r diesen Ereignistyp ein
 *  "Wachhund auf der Lauer liegt". Ist dies der Fall, so wird die entspre-
 *  chende Funktion aufgerufen. Falls diese nun 'TRUE' als Ergebnis liefert,
 *  so wird ganz normal verfahren und das Ereignis an die aufrufende Routine
 *  weitergegeben; ist der Wert aber 'FALSE', so wird das Ereignis sozusagen
 *  unterschlagen und wieder das AES angesprungen, um erneut auf ein Ereignis
 *  zu warten. Bei 'MultiEvent' wird das Ereignis nur aus der Menge aller
 *  aufgetrettenen Ereignisse ausmaskiert und der Rest, der auch leer sein
 *  kann, an die aufrufende Routine weitergegeben. Bei 'HandleEvents', wird
 *  wie bei 'MultiEvent' verfahren, nur werden die Ereignisse nicht zur�ck-
 *  gegeben, sondern die entsprechenden Prozeduren ausgef�hrt.
 *  Bei der Benutzung von 'HandleEvents', ist folgende Besonderheit anzu-
 *  merken: In der Regel werden nur solche Ereignisse vom AES erfragt, f�r
 *  die auch Prozeduren in dem 'ARRAY OF EventProc' angegeben sind. Falls
 *  aber einen Anmeldung f�r ein Nachrichtenereignis mittels 'InstallWatchDog'
 *  vorliegt, so werden auch Nachrichtenereignise erfragt. (Wird eine Nach-
 *  richt �bergeben, die von keiner der angemeldeten Routine bearbeitet wer-
 *  den kann, so ist Sorge getragen, da� das Ereignis nicht verloren geht)
 *  Als Letztes sei noch angemerkt, da� die Aufteilung der Nachrichtenerei-
 *  gnisse in die Unterpunkte nur aus Gr�nden der einfacheren Handhabung
 *  erfolgte.
 *  Dabei gilt: Meldet man eine 'MessageProc' (mit 'unspecMessage') an, so
 *  wird diese bei jeder Nachricht, also sowohl bei AES-Nachrichten, als
 *  auch bei Nachrichten von anderen Applikationen (in der Regel Accesory's).
 *  aufgerufen. Dabei ist zu beachten, da� wann immer man mit 'AESMisc.Write
 *  ToAppl' einen Nachricht absetzt, das erste Wort die Art der Nachricht,
 *  das zweite Wort die Applikationsnummer des Senders und das dritte Wort
 *  die L�nge der Nachricht minus 16 (in Byte) enth�lt.
 *)


FROM SYSTEM     IMPORT WORD;

FROM GrafBase   IMPORT Point, Rectangle;

FROM GEMGlobals IMPORT GemChar, MButtonSet, SpecialKeySet;
                       
FROM AESEvents  IMPORT unspecMessage, menuSelected, windRedraw, windTopped,
                       windClosed, windFulled, windArrowed, windHSlid,
                       windVSlid, windSized, windMoved, windNewTop, accOpen,
                       accClose, ArrowedMode, Event, MessageBuffer,
                       RectEnterMode;
 

TYPE    WatchDogCarrier = ARRAY[0..7] OF WORD;

        (*  ACHTUNG: Der Parameter 'ctrl' sollte bei watch dogs nicht
         *           genutzt werden, da er nur von 'MultiEvent' und
         *           nicht von 'KeyboardEvent' unterst�tzt wird.
         *)
        KeyboardProc    = PROCEDURE (VAR (* key : *) GemChar,
                                     VAR (* ctrl: *) SpecialKeySet): BOOLEAN;

        MouseButtonProc = PROCEDURE ((* clicks: *) CARDINAL,
                                     (* loc   : *) Point,
                                     (* buts  : *) MButtonSet,
                                     (* keys  : *) SpecialKeySet): BOOLEAN;

        MouseRectProc   = PROCEDURE ((* loc : *) Point,
                                     (* buts: *) MButtonSet,
                                     (* keys: *) SpecialKeySet): BOOLEAN;

        MessageProc     = PROCEDURE ((* buffer: *) MessageBuffer): BOOLEAN;

        TimerProc       = PROCEDURE (): BOOLEAN;

        MenuProc        = PROCEDURE ((* title: *) CARDINAL,
                                     (* item : *) CARDINAL): BOOLEAN;

        WindRedrawProc  = PROCEDURE ((* handle: *) CARDINAL,
                                     (* frame : *) Rectangle): BOOLEAN;
                                      
        WindToppedProc  = PROCEDURE ((* handle: *) CARDINAL): BOOLEAN;
        
        WindClosedProc  = PROCEDURE ((* handle: *) CARDINAL): BOOLEAN;
        
        WindFulledProc  = PROCEDURE ((*handle: *) CARDINAL): BOOLEAN;
        
        WindArrowedProc = PROCEDURE ((* handle: *) CARDINAL,
                                     (* mode  : *) ArrowedMode): BOOLEAN;
                                  
        WindHSlidProc   = PROCEDURE ((* handle: *) CARDINAL,
                                     (* pos   : *) CARDINAL): BOOLEAN;
                                  
        WindVSlidProc   = PROCEDURE ((* handle: *) CARDINAL,
                                     (* pos   : *) CARDINAL): BOOLEAN;
                                  
        WindSizedProc   = PROCEDURE ((* handle: *) CARDINAL,
                                     (* frame : *) Rectangle): BOOLEAN;
                                  
        WindMovedProc   = PROCEDURE ((* handle: *) CARDINAL,
                                     (* frame : *) Rectangle): BOOLEAN;
                                  
        WindNewTopProc  = PROCEDURE ((* handle: *) CARDINAL): BOOLEAN;
        
        AccOpenProc     = PROCEDURE ((* id: *) CARDINAL): BOOLEAN;
        
        AccCloseProc    = PROCEDURE ((* id: *) CARDINAL): BOOLEAN;
        
        
        EventProc = RECORD
        
                      CASE event:Event OF
                      
                        keyboard    : keyHdler   :KeyboardProc|
                        mouseButton : butHdler   :MouseButtonProc|
                        firstRect   : stRectHdler:MouseRectProc|
                        secondRect  : ndRectHdler:MouseRectProc|
                        message     :
                                      CASE msgType:CARDINAL OF
                                     
                                        unspecMessage: msgHdler :MessageProc|
                                        menuSelected : menuHdler:MenuProc|
                                        windRedraw   : drawHdler:WindRedrawProc|
                                        windTopped   : topHdler :WindToppedProc|
                                        windClosed   : clsHdler :WindClosedProc|
                                        windFulled   : fullHdler:WindFulledProc|
                                        windArrowed  : arrwHdler:WindArrowedProc|
                                        windHSlid    : hSldHdler:WindHSlidProc|
                                        windVSlid    : vSldHdler:WindVSlidProc|
                                        windSized    : sizeHdler:WindSizedProc|
                                        windMoved    : moveHdler:WindMovedProc|
                                        windNewTop   : newTHdler:WindNewTopProc|
                                        accOpen      : accOHdler:AccOpenProc|
                                        accClose     : accCHdler:AccCloseProc|
                                        
                                      END|
                                      
                        timer       : timeHdler :TimerProc|
                        
                      END;
                      
                    END;


PROCEDURE InstallWatchDog (VAR handle: WatchDogCarrier; proc: EventProc);

        (*  Meldet einen watch dog, d.h. eine auf ein bestimmtes Ereignis
         *  wartende Prozedur an.
         *
         *  Beim Aufruf wird die in 'proc' specifizierte Prozedur f�r
         *  das ebenfalls in 'proc' angegebene Ereignis angemeldet.
         *  'handle' dient einerseits zur Aufnahme einiger Informati-
         *  onen f�r das 'EventHandler'-Modul, als auch zur Identifi-
         *  kation der Prozedur beim Abmelden mit 'DeInstallWatchDog'.
         *  Es ist wichtig, da� 'handle' vom Anmelden bis zum Abmelden
         *  erhalten bleibt, am besten ist die Variable also global
         *  zu definieren.
         *  Es ist ohne Schwierigkeiten m�glich ein und die selbe Pro-
         *  zudur mehrmals mit VERSCHIEDENEN 'handle's anzumelden, al-
         *  so zum Beispiel f�r 'windMoved' und 'windSized' dieselbe
         *  Routine zu verwenden. Doch darf dasselbe 'handle' NIE
         *  gleichzeitig f�r mehrere Anmeldungen herhalten!
         *  Die angemeldetet Routine mu� bei ihrem Aufruf, falls sie
         *  Routinen aus einem GEM-Modul verwendet darauf achten, da�
         *  die richtige GEM-Kennung aktiv ist!
         *
         *  Bei der Terminierung eines Moduls werden alle dort ange-
         *  meldeten Routinen abgemeldet (Siehe 'SysInstallWatchDog')
         *)
         
PROCEDURE SysInstallWatchDog (VAR handle: WatchDogCarrier; proc: EventProc);

        (*  Funktionsweise wie 'InstallWatchDog', nur wird keine autom.
         *  Abmeldung durchgef�hrt.
         *  Diese Routine sollte von residenten und Systemmoduln benutzt
         *  werden.
         *)
         
PROCEDURE DeInstallWatchDog (VAR handle: WatchDogCarrier);

        (*  Meldet die zu 'handle' geh�rende Routine ab.
         *
         *  Danach kann �ber 'handle' wieder frei verf�gt werden.
         *)

PROCEDURE HandleEvents (    noClicks  : CARDINAL;
                            butMask,
                            butState  : MButtonSet;
                            moveDirec1: RectEnterMode; rect1Size: Rectangle;
                            moveDirec2: RectEnterMode; rect2Size: Rectangle;
                            time      : LONGCARD;
                        REF procs     : ARRAY OF EventProc;
                            usedProcs : CARDINAL);

        (*  Bearbeitet eventuell anstehende Ereignisse.
         *
         *  F�hrt einen Aufruf von 'AESEvent.MultiEvent' durch, dabei werden
         *  die Parameter 'noClicks' bis 'time' verwendet. Anschlie�end wer-
         *  den f�r jedes aufgetrettene Ereignis die entsprechenden Routinen
         *  aus 'procs' aufgerufen. Dabei wird mit dem niedrigsten Feldindex
         *  begonnen und f�r jede Routine gepr�ft ab das zugeh�rige Ereignis
         *  aufgetretten ist, falls ja, wird die Routine angesprungen. Gibt
         *  die Prozedur als Ergebnis 'FALSE' zur�ck, so wird das Ereignis
         *  aus der Menge der aufgetrettenen Ereignisse gel�scht.
         *  'usedProcs' gibt an wieviele Feldelemente beachtet werden sollen.
         *  Falls 'usedProcs' gleich Null ist, so werden alle Eintr�ge behan-
         *  delt.
         *  Nach Abarbeitung aller Routinen kehrt 'HandleEvents' zur�ck.
         *)
         
PROCEDURE ShareTime (time: LONGCARD);

        (*  Gibt Accessories oder watch dogs die M�glichkeit auf Ereignisse
         *  zu reagieren.
         *
         *  Diese Prozedur f�hrt einen Aufruf von 'HandleEvents' aus, der
         *  dazu f�hrt, da� nach der angegebenen Zeit 'time' (in ms) zu-
         *  r�ckgekehrt wird.
         *  Sinn und Zweck dieser Routine ist, da� eventuell im Hinter-
         *  grund arbeitende Accessorys zum Zug kommen und das zweitens
         *  watch dogs (s.o.) die auf message events angesetzt sind, vom
         *  AES mit Nachrichten (z.B. Redraws) versorgt werden k�nnen.
         *  Ein Beispiel f�r die Anwendung bietet 'TextWindows':
         *  Benutzt ein Programm nur Fenster von 'TextWindows' und will es
         *  dem Anwender die Gelegenheit zur Manipulation dieser Fenster ge-
         *  ben, ohne eine Eingabeoperation durchf�hren zu m�ssen, so kann
         *  es zum Beispiel regelm��ig 'ShareTime (0L)' aufrufen.
         *)

PROCEDURE FlushEvents;

        (*  Holt solange Nachrichtenereignisse vom AES und verteilt Sie an
         *  die angemeldeten watch dogs, bis keine mehr anstehen oder sie
         *  nicht mehr angenommen werden.
         *
         *  Ist besser f�r Redraws geeignet als 'ShareTime', da oft mehrer
         *  Redraw-Ereignisse anstehen, die gleich alle abgearbeitet werden
         *  sollen.
         *)


END EventHandler.