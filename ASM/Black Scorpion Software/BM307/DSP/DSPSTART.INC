
;-----------------------------------------------------------------------*
;	Initialise module						*
;-----------------------------------------------------------------------*
KickStart:
;-----------------------------------------------------------------------*
;	Disable mask ROM						*
;-----------------------------------------------------------------------*
	bclr		#2,omr
;-----------------------------------------------------------------------*
;	General purpose I/O						*
;-----------------------------------------------------------------------*
	movep		#0,x:HCR
	movep		#1,x:PBC
;-----------------------------------------------------------------------*
;	Start program							*
;-----------------------------------------------------------------------*
	jmp		RealStart

