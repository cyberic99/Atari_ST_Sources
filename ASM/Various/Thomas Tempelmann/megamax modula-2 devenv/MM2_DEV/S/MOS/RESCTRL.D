DEFINITION MODULE ResCtrl;

FROM SYSTEM IMPORT BYTE, WORD;

FROM MOSGlobals IMPORT MemArea;

(*
 * Dies Modul bietet Funktionen f�r Systemmodule, die Ressourcen verwalten
 * und sich dazu Sys-Funktionen bedienen (und mit $Y+ �bersetzt werden).
 *
 * Problemerl�uterung:
 *   Ein Systemmodul, das 'Sys'-Funktionen bietet oder globale bzw. externe
 * Variablen oder Ressourcen kontrolliert (z.B. Interrupts) sollte sich selbst
 * auch der Sys-Funktionen bedienen.
 *   Beispielsweise kann ein Modul im Modulk�rper Speicher mit SysAlloc
 * anfordern oder einen Systemvektor des TOS ver�ndern. Wird das Modul
 * nicht mehr gebraucht und aus dem Speicher entfernt, mu� nat�rlich der
 * Speicher zur�ckgegeben bzw. der Vektor restauriert werden. W�rde man
 * das mit Hilfe der Funktion 'PrgCtrl.CatchProcessTerm' tun, w�rde es
 * normalerweise funktionieren.
 *  Das Problem entsteht erst, wenn das Modul, das dieses Systemmodul im-
 * portiert, sich resident macht. Wenn der Proze� dann endet, wird ja
 * der vom Systemmodul geforderte 'CatchProcessTerm' aktiv und das
 * Systemmodul w�rde seine Ressourcen schlie�en. Das darf es dann aber
 * noch gar nicht, weil es ja noch resident bleibt und weiterhin von
 * anderen Modulen ben�tigt wird.
 *   Aus diesem Grund gibt es hier die Funktion 'CatchRemoval', die,
 * entgegen 'CatchProcessTerm', das Modul erst dann informiert, wenn
 * es nicht mehr ben�tigt, sprich importiert, wird.
 *
 *   Deshalb ist immer dann, wenn man daran denkt, 'CatchProcessTerm' zu
 * verwenden, zu pr�fen, ob nicht der oben beschriebene Fall eintreten
 * kann und dann stattdessen 'CatchRemoval' einzusetzen ist.
 *   Als Faustregel gilt:
 *    - 'CatchRemoval' f�r Freigabe von Sys-Ressourcen bei Ressource-
 *      verwaltenden Modulen.
 *    - 'CatchProcessTerm' bei Hauptmodulen (denn hier hat das Modul
 *      ja selbst die Kontrolle dar�ber, wann es sich resident macht
 *      und wieder freigibt) und Freigabe von Ressourcen des untersten
 *      Levels bei Ressource-verwaltenden Modulen (erg�nzend zu den
 *      "Envelopes").
 *)

TYPE  RemovalCarrier = ARRAY [0..15] OF WORD;

PROCEDURE CatchRemoval ( VAR hdl: RemovalCarrier; info: PROC; wsp: MemArea );
  (*
   * Meldet eine Prozedur an, die aufgerufen wird, wenn das Modul,
   * das die Prozedur enth�lt, nicht mehr ben�tigt wird und aus dem
   * Speicher entfernt werden kann.
   *
   * 'wsp' ist der Stack, der 'info' beim Aufruf zugeteilt wird. 'wsp.bottom'
   * darf NIL sein, dann wird der normale Programm-Stack verwendet.
   *
   * Diese Funktion (und nicht etwa 'CatchProcessTerm') ist deshalb
   * das exakte Gegenst�ck zum Aufruf des Modulk�rpers.
   *
   * Dies ist der Fall, wenn
   *  a) das Modul in einem Programm eingelinkt ist und das Programm
   *     normal beendet;
   *  b) das Modul durch einen Import vom Loader (also durch Load-Time
   *     Link) dazugeladen und gestartet wurde und nun wieder freigegeben
   *     werden kann, da der Proze� wieder endet;
   *  c) das Modul von einem Modul importiert wird, das sich mit
   *     'ModCtrl.InstallModule' resident gemacht hatte und nach
   *     einem Aufruf von 'ReleaseModule', wie unter b), entfert wird.
   *
   * Wird ein Modul lediglich vom Loader (mittels 'LoadModule') geladen,
   * aber nicht aufgerufen, z�hlt das entsprechende Ausladen des Moduls
   * nicht zu den obigen F�llen. Vielmehr wird bei geladenen Modulen
   * so verfahren, als wenn das Modul jedesmal neu geladen und wieder
   * entladen wird.
   *
   * Somit ist diese Funktion dann zu verwenden, wenn ein Modul Ressourcen
   * dynamisch bei seiner Initialisierung �ffnet, die genau dann wieder
   * geschlossen werden d�rfen, wenn das Modul nicht mehr ben�tigt wird.
   * Normalerweise k�nnte man das dann mit 'PrgCtrl.CatchProcessTerm'
   * bewerkstelligen. Nur ist es dann nicht m�glich, das Modul in Pro-
   * grammen zu verwenden, die sich mit 'InstallModule' resident machen.
   *
   * Wird also z.B. in einem Modul im K�rper Speicher angefordert, sollte
   * dieser mit der Sys-Funktion (SysAlloc) angefordert werden und �ber
   * 'CatchRemoval' der Speicher wieder freigegeben werden.
   *
   * WICHTIG: Das benutzende Modul mu� mit der Directive "$Y+" �bersetzt
   *          werden!
   *)

PROCEDURE Resident (): BOOLEAN;
  (*
   * Liefert TRUE, wenn der akt. Proze� z.Zt. resident ist.
   * Es ist zu beachten, da� dieser Zustand nicht im Modulk�rper schon
   * ermittelt werden soll, da das Hauptmodul, das sich evtl. resident
   * macht, dies erst sp�ter durchf�hren kann.
   *)


PROCEDURE Private ( n: CARDINAL; VAR d: ARRAY OF BYTE );
  (*
   * interne Systemfunktion
   *)

END ResCtrl.
