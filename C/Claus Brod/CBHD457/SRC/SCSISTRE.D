DEFINITION MODULE ScsiStreamer;
(****************************************************************************
 *
 *
 * $Source: E:\HM2\LIB\se\rcs\scsistre.d,v $
 *
 * $Revision: 1.1 $
 *
 * $Author: S_Engel $
 *
 * $Date: 1996/02/03 19:32:12 $
 *
 * $State: Exp $
 *
 *****************************************************************************
 * History:
 *
 * $Log: scsistre.d,v $
 * Revision 1.1  1996/02/03  19:32:12  S_Engel
 * Initial revision
 *
 *
 *
 ****************************************************************************)

FROM SYSTEM IMPORT ADR, ADDRESS;


PROCEDURE Rewind(Imed : BOOLEAN; TimeoutSeconds : LONGCARD) : BOOLEAN;
  (*
   * RewindCmd spult das 'Band' bei sequentiellen SCSI-Ger�ten zur�ck.
   * Ist Imed gleich FALSE, so wird gewartet bis das 'Band' zur�ck
   * gespult worden ist. Ansonsten wird nicht gewartet. TimeoutSeconds
   * ist die Auszeit in Sekunden (bei Imed=FALSE entsprechend hoch
   * setzen).
   *)

CONST SpaceBlock        = 0;
      SpaceMark         = 1;
      SpaceSerie        = 2;
      SpaceEnd          = 3;
      SpaceSetmarks     = 4;
      SpaceSetmarkSerie = 5;

PROCEDURE Space(Code : SHORTCARD; Count : LONGINT;
                   TimeoutSeconds : LONGCARD) : BOOLEAN;
  (*
   * SpaceCmd sucht/�berspult Count Dinge - je nach Code - auf einem 
   * sequentiellen Medium (Count<0 r�ckw�rts).
   * Code = SpaceBlock  Count Bl�cke �berspulen
   *      = SpaceMark   Count Filemarks �berspulen
   *      = SpaceSerie  bis Serie von Count Filemarks spulen
   *      = SpaceEnd    bis zum Ende des beschriebenen Bereichs
   *)

PROCEDURE WriteFilemark(Imed : BOOLEAN; Number : SHORTCARD; TimeoutSeconds : LONGCARD) : BOOLEAN;
  (*
   * WriteFilemarkCmd schreibt Number Filemarks auf ein sequentielles
   * Medium. Ist Imed gleich FALSE, so wird gewartet bis die Marken
   * geschrieben sind.
   *)


PROCEDURE Load(Imed, Ret, Eot, Load : BOOLEAN;
               TimeoutSeconds : LONGCARD) : BOOLEAN;
  (*
   * LoadUnloadCmd ist das StartStopCmd f�r sequentielle Medien. Die 
   * Flags haben vollgende Bedeutung:
   * Imed=TRUE  Ausf�hrung nicht abwarten
   * Ret =TRUE  sequentielles Medium wird einmal ganz vor- und
   *            zur�ckgespult um z.B. bei B�ndern Spannungen zu 
   *            beseitigen (retension)
   * Eot =TRUE  vor entladen Ende des Mediums anfahren (END OF tape)
   * Laod=TRUE  Medium laden
   *) 

PROCEDURE Read(TransferLen : SHORTCARD; ADR : ADDRESS; TimeoutSeconds : LONGCARD) : BOOLEAN;
PROCEDURE ReadNum(VAR TransferLen : SHORTCARD; ADR:ADDRESS; TimeoutSeconds : LONGCARD) : BOOLEAN;
  (*
   * SeqReadCmd liest TransferLen Bl�cke von einem sequentiellen Medium
   * an die durch ADR angegebene Adresse in den Speicher.
   *)


PROCEDURE Write(TransferLen : SHORTCARD; ADR : ADDRESS; TimeoutSeconds : LONGCARD) : BOOLEAN;
PROCEDURE WriteNum(VAR TransferLen : SHORTCARD; ADR : ADDRESS; TimeoutSeconds : LONGCARD) : BOOLEAN;
  (*
   * SeqWriteCmd schreibt TransferLen Bl�cke aus dem Speicher, der bei
   * ADR beginnt, auf ein sequentielles Medium.
   *)

PROCEDURE Erase(TimeoutSeconds : LONGCARD) : BOOLEAN;
  (*
   * EraseCmd l�scht das im SCSI-Ger�t eingelegte sequentielle Medium.
   *)


PROCEDURE RequestBlockAdr(VAR BlockAdr:LONGCARD) : BOOLEAN;
  (* 
   * Aktuelle Blockadresse eines sequentiellen SCSI-Ger�tes abfragen.
   * Ein Kommando mit dem hier verwendeten Code $02 ist in der ANSI-Norm 
   * nicht spezifiziert, sondern ist als vom Hersteller frei verwendbar
   * ausgewiesen. Tandberg-Streamer kennen dieses Kommando.
   *)

PROCEDURE SeekBlock(Imed : BOOLEAN;
                    BlockAdr, TimeoutSeconds : LONGCARD) : BOOLEAN;
  (*
   * SeqSeekBlockCmd spult das 'Band' eines sequentiellen SCSI-Ger�tes
   * auf den Block mit der Nummer BlockAdr. Ist Imed gleich FALSE, so wird 
   * gewartet bis das 'Band' positioniert ist. Ansonsten wird nicht 
   * gewartet. TimeoutSeconds ist die Auszeit in Sekunden (bei Imed=FALSE 
   * entsprechend hoch setzen). Ein Kommando mit dem hier verwendeten Code 
   * $0C ist in der ANSI-Norm nicht spezifiziert, sondern ist als vom 
   * Hersteller frei verwendbar ausgewiesen. Tandberg-Streamer kennen 
   * dieses Kommando.
   *)


(*-------------------------------------------------------------------------*)
(*-                                                                       -*)
(*- Locate ist das Kommando zur Positionierung eines Streamers            -*)
(*- auf einer vorgegebenen Blocknummer.                                   -*)
(*- SCSI-Opcode $2B                                                       -*)
(*- Quelle : SCSI-2 draft proposal                                        -*)
(*-                                                                       -*)
(*- BlockAdresstype                                                       -*)
(*-   TRUE  : Block-Adresse als Device-Specific Value                     -*)
(*-   FALSE : Adresse als logische Block-Adresse                          -*)
(*- ChangePartition                                                       -*)
(*-   TRUE  : Band-Partition wechseln, Partitionsnummer �bergeben         -*)
(*-   FALSE : Partition beibehalten                                       -*)
(*-                                                                       -*)
(*-------------------------------------------------------------------------*)
PROCEDURE Locate(BlockAdresstype : BOOLEAN;
                 ChangePartition : BOOLEAN;
                 Imed            : BOOLEAN;
                 BlockAdress     : LONGCARD;
                 Partition       : SHORTCARD;
                 TimeoutSeconds  : LONGCARD) : BOOLEAN;

(*-------------------------------------------------------------------------*)
(*-                                                                       -*)
(*- Read Position ist das Kommando zur Abfrage der aktuellen              -*)
(*- Bandposition                                                          -*)
(*- SCSI-Opcode $34                                                       -*)
(*-                                                                       -*)
(*- BlockAdresstype                                                       -*)
(*-   TRUE  : Block-Adresse als Device-Specific Value                     -*)
(*-   FALSE : Adresse als logische Block-Adresse                          -*)
(*- Partition : Nummer der aktuellen Partition                            -*)
(*- BlockAdress : Adresse des n�chsten zu �bertragenden Blockes           -*)
(*-                                                                       -*)
(*- die Werte f�r BOP, EOP, Last Block Location, Number of Blocks in      -*)
(*- Buffer Number of Bytes per Buffer werden bei der Prozedurantwort      -*)
(*- unterschlagen.                                                        -*)
(*- Zur Auswertung dieser Parameter bitte ALIASCMD.I beachten.            -*)
(*-                                                                       -*)
(*-------------------------------------------------------------------------*)
PROCEDURE ReadPosition(    BlockAdresstype : BOOLEAN;
                       VAR Partition       : SHORTCARD;
                       VAR BlockAdress     : LONGCARD) : BOOLEAN;



END ScsiStreamer.
