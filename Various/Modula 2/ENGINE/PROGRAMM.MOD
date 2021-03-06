(*********************************************************************)
(* Hauptmodul des �bersetzungsprogrammes                             *)
(*-------------------------------------------------------------------*)
(*             Datum:      Autor:             Kommentar:             *)
(* Erstellung: 09.10.1991  Frank Mathy                               *)
(* �nderung:                                                         *)
(*********************************************************************)

MODULE Programm;


FROM Woerterbuch IMPORT LiesWoerterbuch,SchreibWoerterbuch,
                        LoeschWoerterbuch;
FROM Textdatei IMPORT UebersetzeText;


PROCEDURE Uebersetze;
(* Hauptprozedur des �bersetzungsprogrammes *)
BEGIN
LiesWoerterbuch;
UebersetzeText;
SchreibWoerterbuch;
LoeschWoerterbuch;
END Uebersetze;


BEGIN
(* Hier Platz f�r eventuelle Initialisierungen.  *)
Uebersetze;
(* Hier Platz f�r Aktionen vor dem Programmende. *)
END Programm.
