MODULE Monitor;
(*$L-*)

(*
 * Dieses Modul zeigt, wie man einen residenten Debugger, wie z.B. TEMPLEMON,
 * automatisch bei jedem Start eines Moduls aufrufen lassen kann, um dann
 * beispielsweise Haltepunkte (Breakpoints) zu setzen.
 *)

FROM Loader IMPORT Monitor;

FROM ModCtrl IMPORT InstallModule, ReleaseModule, FirstModuleStart;

FROM MOSGlobals IMPORT MemArea;

FROM SYSTEM IMPORT ASSEMBLER;

VAR oldV: PROC;
    wsp: MemArea;


CONST   RegD0 = 04;
        RegD1 = 08;
        RegD2 = 12;
        RegD3 = 16;
        RegD4 = 20;
        RegD5 = 24;
        RegD6 = 28;
        RegD7 = 32;
        RegA0 = 36;
        RegA1 = 40;
        RegA2 = 44;
        RegA3 = 48;
        RegA4 = 52;
        RegA5 = 56;
        RegA6 = 60;
        RegA7 = 64;
        RegSR = 02;
        RegPC = 68;
        RegUSP = 72;
        RegSSP = 76;
        RegBEV = 80;
        RegAEV = 84;

PROCEDURE trc;
  BEGIN
    ASSEMBLER
        ; Diese Routine wird von TEMPLEMON regelm��ig im Trace-Modus
        ; aufgerufen.
        ; In A0 erh�lt sie einen Zeiger auf die - geretteten - CPU-
        ; Register. Die obigen Konstanten k�nnen benutzt werden, um
        ; auf sie zuzugreifen.
        ; In D0.B mu� die Routine einen Wert ungleich Null liefern, wenn
        ; der Trace-Modus unterbrochen werden soll.
        ;
        ; Als (fiktives) Beispiel wird �berwacht, da� die Register
        ; D4 und D5 nicht den gleichen Wert enthalten.

        MOVE.L  RegD4(A0),D0
        CMP.L   RegD5(A0),D0
        SEQ     D0              ; wenn D4=D5, dann wird D0.B zu $FF, sonst $00
    END
  END trc;

PROCEDURE mon;
  BEGIN
    ASSEMBLER
        ; Diese Routine wird beim Start eines Moduls aufgerufen.
        ;
        ; Man gelangt dann in den TEMPLEMON, der nat�rlich installiert
        ; sein mu�, wo mit "BU RD0" der User-Trace-Vektor auf die
        ; Funktion 'trc' (oben) gesetzt werden kann.
        ; Dann kann mit "T+" der Trace-Modus aktiviert und mit "G" und
        ; der Taste /A/ das Programm im Trace-Modus gestartet werden.
        ; (N�heres siehe TEMPLEMON-Dokumentation)
        ;
        ; Nat�rlich kann auch auf die obige User-Trace-Routine verzichtet
        ; werden und stattdessen z.B. das geladene Programm disassembliert
        ; werden.

        MOVE.L    #trc,D0
        BREAK
    END
  END mon;

PROCEDURE restore;
  BEGIN
    Monitor:= oldV
  END restore;

BEGIN
  IF FirstModuleStart () THEN
    (*
     * Die Prozedur 'mon' wird so installiert, da� sie bei jedem folgenden
     * Start eines Moduls (�ber den Loader) aufgerufen wird.
     *)
    oldV:= Monitor;              (* alten Vektor retten *)
    Monitor:= mon;               (* Routine 'mon' installieren *)
    wsp.bottom:= NIL;
    InstallModule (restore,wsp)  (* Dieses Modul resident machen *)
  ELSE
    (*
     * Beim zweiten Start dieses Programms wird wieder alles abgemeldet.
     *)
    restore;
    ReleaseModule
  END
END Monitor.
