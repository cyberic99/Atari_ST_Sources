MODULE Refresh;
(* � 1996 by ROLF SCHRADER.    * 4.2.96 *)
(*
             Blo� 'ne klitzekleine T��le, um Pixel-M�ll vom Schirm zu r�umen.
*)
(*$S-,$T-,$Q+*)

IMPORT AEB;

PROCEDURE DeskRefresh;
 BEGIN AEB.FormFinish (0,0, 9999,9999);
       AEB.ApplYielT (7);
   END DeskRefresh;

PROCEDURE RunAccPrg (VAR AccsMenu: ARRAY OF CHAR; Job: PROC);
 VAR   MenuId: INTEGER;  M: AEB.MsgPipeR;
 BEGIN IF ~ AEB.ApplIsAcc ()  THEN Job; RETURN END;
       MenuId := AEB.MenuRegist (ApId, AccsMenu);
  LOOP AEB.EventMessage (M);                        (* ACC-typische Ananta.*)
    IF (M.Type = AEB.ACCOPEN) THEN Job END; END (*L*); END RunAccPrg;

VAR   ApId: INTEGER;
BEGIN ApId := AEB.ApplInit ();
      RunAccPrg ("  Desk Refresh ", DeskRefresh);
      AEB.ApplExit;  END Refresh .
