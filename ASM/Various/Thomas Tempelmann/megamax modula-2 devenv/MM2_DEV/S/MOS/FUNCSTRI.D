DEFINITION MODULE FuncStrings;

(*
   String - Bibliothek

   Die hiesigen Funktionen bedienen sich einer Erweiterung des Megamax
   Compilers: Er erlaubt beliebig gro�e Funktionsergebnisse.

   Die hier vorhandenen Funktionen liefern alle als Funktionsergebnis
   den Typ 'String' (siehe Strings-Modul).

   Dies erlaubt das Bilden von "Ausdr�cken", wie z.B:
       s:= UpStr ( ConcStr ( pfad, name ) );

   Achtung: Die Verwendung dieser Funktionen erschwert das �bertragen
   solcher Programme auf andere Modula-2 Systeme (allerdings gibt es
   mehrere Systeme, die diese Erweiterung haben) !

   Die Funktionen sind alle zu denen aus 'Strings' verwandt. Der 'valid'
   Parameter wird hier nicht ben�tigt - illegale �bergaben oder �berl�ufe
   werden ignoriert.
*)

IMPORT Strings;

TYPE String = Strings.String;


PROCEDURE Str ( REF source : ARRAY OF CHAR): String;
  (*
   * Dient zum Zuweisen beliebiger String-Variablen auf eine Variable
   * vom Typ 'String' (80 Zeichen L�nge).
   *)

PROCEDURE DelStr ( REF source : ARRAY OF CHAR;
                       pos    : INTEGER;
                       len    : INTEGER ): String;
  (*
   * L�scht aus 'source' ab Position 'pos' 'len' Zeichen.
   *)

PROCEDURE ConcStr ( REF first, second: ARRAY OF CHAR ): String;
  (*
   * Liefert einen zusammengef�gten String aus 'first' und 'second'.
   *)

PROCEDURE InsStr ( REF this : ARRAY OF CHAR;
                       at   : INTEGER;
                   REF into : ARRAY OF CHAR ): String;
  (*
   * F�gt 'this' an Position 'at' in 'into' ein.
   *)

PROCEDURE CopyStr ( REF source : ARRAY OF CHAR;
                        from   : INTEGER;
                        len    : INTEGER ): String;
  (*
   * Liefert Teilstring aus 'source' ab Position 'from' mit maximaler
   * L�nge 'len'.
   *)

PROCEDURE UpStr ( REF source: ARRAY OF CHAR ): String;
  (* Liefert String in Gro�buchstaben. *)

PROCEDURE LowStr ( REF source: ARRAY OF CHAR ): String;
  (* Liefert String in Kleinbuchstaben. *)

PROCEDURE EatSpc ( REF source: ARRAY OF CHAR ): String;
  (* Liefert String ohne Leerzeichen. *)

PROCEDURE BlankDel ( REF source: ARRAY OF CHAR ): String;
  (* Liefert String ohne Leerzeichen und ohne TAB-Zeichen. *)

PROCEDURE LeadBlankDel ( REF source: ARRAY OF CHAR ): String;
  (* Liefert String ohne f�hrende Leerzeichen und TABs *)

PROCEDURE TrailBlankDel ( REF source: ARRAY OF CHAR ): String;
  (* Liefert String ohne anh�ngende Leerzeichen und TABs *)

END FuncStrings.
