DEFINITION MODULE VDIInquires;


(*  Megemax Modula-2 GEM-Library :  Die VDI Nachfragefunktionen
 *
 *  Autor: Manuel Chakravarty           Erstellt :  04.11.87
 *
 *  Version   2.2     V#0015
 *)
 
(*      Dieses Modul dient zum Erfragen der mit den Routine von 'VDIAttributs'
 *      gesetzten Parameter. Dar�ber hinaus k�nnen noch einige andere Werte
 *      ermittelt werden.
 *      Die 'Extended Inquire'-Funktion ist nicht aufgef�hrt, da die von ihr
 *      gelieferten Parameter, unter anderem, mit 'GEMEnv.DeviceParameter'
 *      erfragt werden k�nnen.
 *      Au�erdem ist 'Inquire Input Mode' nicht vorhanden, da es von dem
 *      Modul 'VDIInputs' schon implizit verwendet wird.
 *)
 
 
FROM GrafBase   IMPORT Rectangle, WritingMode;
 
FROM GEMGlobals IMPORT LineType, MarkerType, FillType, THorJust,
                       TVertJust, LineEnding;

FROM GEMEnv     IMPORT DeviceHandle;
 

PROCEDURE GetColorDef (    handle : DeviceHandle;
                           color  : CARDINAL;
                           set    : BOOLEAN;
                       VAR r, g, b: CARDINAL);
                       
        (*  Damit kann man die RGB-Anteile des Farbindex 'color' erfragen.
         *  Ist 'set = FALSE', so werden die gesetzten Werte zur�ckgegeben,
         *  sonst liefert die Prozedur die auf dem Ger�t realisierte Farb-
         *  mischung. Dabei enth�lt 'r' den Rot-, 'g' den Gr�n- und 'b'
         *  den Blauanteil.
         *  Konnten die Werte, zum Beispiel weil der Index nicht existiert,
         *  nicht ermittelt werden, so ist 'GemError () = TRUE'.
         *)

PROCEDURE GetLineStyle (    handle: DeviceHandle;
                        VAR typ   : LineType;
                        VAR color : CARDINAL;
                        VAR mode  : WritingMode;
                        VAR begin,
                            end   : LineEnding;
                        VAR width : CARDINAL);
                        
        (*  Erfragt die Attribute f�r das Linienzeichnen. Es ist 'typ'
         *  der Linientyp, 'color' der verwendete Farbindex, 'mode' der
         *  Schreibmodus und 'width' die Strichst�rke.
         *)
                       
PROCEDURE GetMarkerStyle (    handle: DeviceHandle;
                          VAR typ   : MarkerType;
                          VAR color : CARDINAL;
                          VAR mode  : WritingMode;
                          VAR height: CARDINAL);
                          
        (*  Die Makierungsattribute werden ermittelt. Dabei ist 'typ'
         *  die Art der Makierung, 'color' die Makierungsfarbe, 'mode'
         *  der Schreibmodus und 'height' die H�he der Makierung.
         *)
                         
PROCEDURE GetFillStyle (    handle: DeviceHandle;
                        VAR typ   : FillType;
                        VAR color : CARDINAL;
                        VAR index : CARDINAL;
                        VAR mode  : WritingMode;
                        VAR peri  : BOOLEAN);
                        
        (*  Liefert die Modi f�r das F�llen von Fl�chen. Es ist 'typ'
         *  der F�lltyp, 'color' die F�llfarbe, 'index' der Index des
         *  eventuell verwendeten Musters, 'mode' der Schreibmodus und
         *  'peri' zeigt an, ob die gef�llte Fl�che umrahmt wird.
         *)
                       
PROCEDURE GetTextStyle (    handle                  : DeviceHandle;
                        VAR font, color, angle      : CARDINAL;
                        VAR hor                     : THorJust;
                        VAR vert                    : TVertJust;
                        VAR mode                    : WritingMode;
                        VAR charW, charH, boxW, boxH: CARDINAL    );
                        
        (*  Die von dieser Prozedur ermittelten Parameter sind bei Text-
         *  ausgaben relevant. Dabei spezifiziert:
         *
         *  'font'   -- den verwendeten Zeichensatz
         *  'color'  -- den benutzten Farbindex
         *  'angle'  -- den Winkel der Grundlinie zur Horizontalen
         *  'hor'    -- die horizontale Justierung
         *  'vert'   -- die vertikale Justierung
         *  'mode'   -- den aktuellen Schreibmodus
         *  'charW'  -- die Zeichenbreite
         *  'charH'  -- die Zeichenh�he
         *  'boxW'   -- die Breite einer Zeichenbox
         *  'boxH'   -- die H�he einer Zeichenbox
         *)
                       
PROCEDURE TextExtent (handle: DeviceHandle; REF str: ARRAY OF CHAR): Rectangle;

        (*  Diese Funktion berechnet Ausma�e des Rechtecks, das die
         *  Zeichenkette 'str', w�rde sie ausgegeben, belegt.
         *)

PROCEDURE GetCharSize (    handle: DeviceHandle;
                           ch    : CHAR;
                       VAR width,
                           dLeft,
                           dRight: CARDINAL);
                       
        (*  F�r das Zeichen 'ch' wird in dieser Routine die Zeichenbreite
         *  und der Abstand des Zeichens vom linken ('dLeft') und vom
         *  rechten Rand ('dRight'),der Zeichenzelle, erfragt.
         *)

PROCEDURE GetFaceName (    handle: DeviceHandle;
                           num   : CARDINAL;
                       VAR name  : ARRAY OF CHAR);

        (*  Es wird der Name ('name') des Zeichensatzes mit der Kennummer
         *  'num' geliefert.
         *  Der Systemzeichensatz hat die Nummer 1, weitere, mit LoadFonts
         *  nachgeladene Fonts sind ab 2 durchnumeriert.
         *  Au�erdem wird hiermit die Zugriffskennung eines Fonts
         *  ermittelt, um ihn daraufhin mit "VDIAttributes.SetTextFace"
         *  als Fonts f�r die Textausgabe (GrafText) zu aktivieren.
         *  Leider wurde der Parameter hierf�r bei dieser Funktion
         *  vergessen. Sie k�nnen ihn aber leicht ermitteln, indem Sie
         *  mithilfe des Moduls "GEMBase" nach dem Aufruf von "GetFaceName"
         *  das erste Integer-R�ckgabefeld auslesen. Beispielsweise so:
         *   VAR aespb: GEMBase.AESPB; vdipb: GEMBase.VDIPB;
         *    ...
         *    GEMBase.GetPBs (gemHdl, vdipb, aespb);
         *    GetFaceName (devHdl, fontNr, fontName);
         *    fontHandle:= vdipb.iooff^[0];
         *    SetTextFace (devHdl, fontHandle);
         *  Ein ausf�hrlicheres Beispiel finden Sie im DEMO-Modul "TextDemo".
         *)
         
PROCEDURE GetCellArray (    handle             : DeviceHandle;
                            frame              : Rectangle;
                            rowLength, numRows : CARDINAL;
                        VAR usedElems, usedRows: CARDINAL;
                        VAR undef              : BOOLEAN;
                        VAR colArray           : ARRAY OF CARDINAL);

        (*  Mit dieser Prozedur kann man eine 'Cell Array'-Definition er-
         *  fragen.
         *  Es ist 'frame' der Rechteckbereich, der erfragt werden soll,
         *  'rowLength' die L�nge einer Zeile im Array und 'numRows' die
         *  Anzahl der Zeilen. 'usedElems' liefert die Anzahl der pro Zeile
         *  benutzten Elemente, 'usedRows' die Zahl der benutzten Zeilen
         *  und 'undef' besagt ob die Farbwerte ermittelt werden konnten
         *  ('undef = FALSE' bedeutet: Kein Fehler). 'colArray' enth�lt
         *  die ermittelten Farbindizies.
         *
         *  HINWEIS: Diese Routine ist in der aktuellen TOS Version nicht
         *           implementiert.
         *)

PROCEDURE GetFaceInfo (    handle                 : DeviceHandle;
                       VAR minADE, maxADE         : CARDINAL;
                       VAR bottom, descent,
                           half, ascent, top      : CARDINAL;
                       VAR maxWidth, deltaXSpecial,
                           leftOff, rightOff      : INTEGER);
                       
        (*  Erfragt einige Informationen �ber den aktuellen Zeichensatz.
         *
         *  'minADE'    -- Die Ordinalzahl des ersten darstellbaren Zeichens
         *  'maxADE'    -- Die Ordinalzahl des letzen darstellbaren Zeichens
         *
         *  Abstand von der Grundlinie (base Line) f�r,
         *
         *  'bottom'        -- die untere Grenze der Zeichenbox (bottom line)
         *  'descent'       -- die Grenze der Unterl�ngen (descent line)
         *  'half'          -- die Grenze f�r Kleinbuchstaben (half line)
         *  'ascent'        -- die Grenze f�r Gro�buchstaben (ascent line)
         *  'top'           -- die obere Grenze der Zeichenbox (top line)
         *
         *  'maxWidth'      -- Die Zellenbreite des breitesten Zeichens
         *  'deltaXSpecial' -- Horizontale Verbreiterung bei Spezialeffekten
         *  'leftOff'       -- Linker Offset f�r Spezialeffekte
         *  'rightOff'      -- Rechter Offset f�r Spezialeffekte
         *)


END VDIInquires.