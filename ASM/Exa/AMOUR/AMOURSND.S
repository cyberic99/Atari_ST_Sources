env	macro
	btst	#1,$ffffa202.w
	beq.s	*-4-2
	endm
rec	macro
	btst	#0,$ffffa202.w
	beq.s	*-4-2
	endm
	include	MACRO&CO.S
	 	SECTION TEXT
	jsr	load_dsp_prog
	jsr	RESERVE_ECRANS
	;vsync
	;aset_video	#6
	;aset_screen	LOG
	;vsync
	move.l	$70.w,-(sp)
	move.l	a7,old_pile
	move.l	#VBL,$70.w
	move.l	#INTER_BOUCLE,-(sp)
	move.l	#BOUCLE2,-(sp)
	sf	trk
	
BOUCLE1
	vsync
	rept	4
	bsr	PLAQUE	
	endr
	trap	#4
	bra	BOUCLE1
BOUCLE2
	vsync
	rept	4
	bsr	PLAQUE_MAP
	endr
	trap	#4
	bra	BOUCLE2

INTER_BOUCLE
	st	TRK
	move.l	LOG,a0
	move.l	PHYS,a1
	move.w	#256-1,d7
.Y	move.w	#192-1,d6
.X	move.l	(a0)+,(a1)+
	dbra	d6,.X
	add.w	#768,a0
	add.w	#768,a1
	dbra	d7,.Y
	lea	script,a0
.next
	move.l	(a0),d0
	bmi.s	boucle3
	mulu	#16384,d0
	add.l	#ima,d0
	move.l	d0,(a0)+
	bra.s	.next	
boucle3

	clr.w	$208.w
.lop
	vsync
	tst.b	$208.w
	beq.s	.lop
	clr.w	$208.w

BOUCLE
	vsync
	move.l	LOG,d0
	move.l	PHYS,LOG
	move.l	d0,PHYS

	movec	cacr,d0
	bset	#9,d0
	movec	d0,cacr
	bsr	GRAF_SCREEN_2
	movec	cacr,d0
	bclr	#9,d0
	movec	d0,cacr

	move.l	ptr_table_rota(pc),a0
	subq	#1,pt
	bpl.s	.no_pt
	move	#100,pt
	lea	4(a0),a0
	cmp	#$1234,(a0)
	bne.s	.cont
	move.l	#table_rota2,a0
.cont
	move.l	a0,ptr_table_rota
	move.w	(a0)+,inc_sin1
	move.w	(a0)+,inc_sin2
.no_pt
	movem.w	inc_sin1(pc),d0-d3
	add	d0,d2
	add	d0,angle_x
	add	d1,d3
	and.w	#511,d2
	and.w	#511,d3
	movem.w	d2-d3,pt_sin1
	moveq	#0,d0
	move.w	table1(pc,d2*2),d0
	add.w	(table2.l,d3*2),d0
	asr	#2,d0
	add	#600,d0
	move.w	d0,zoom_x
	tst	FLAG_FIN
	beq	BOUCLE
	jmp	FIN

inc_sin1	dc.w	0
inc_sin2	dc.w	0
pt_sin1		dc.w	0
pt_sin2		dc.w	0
pt		dc.w	0
ptr_table_rota	dc.l	table_rota
table_rota
	dc.w	2,2
	dc.w	1,2
table_rota2
	dc.w	2,2
	dc.w	1,3
	dc.w	-1,2
	dc.w	-3,3
	dc.w	-2,4
	dc.w	-2,3
	dc.w	-2,4
	dc.w	-2,4
	dc.w	$1234
table1	incbin	table1.dat
table2	incbin	table2.dat

PLAQUE_MAP
	lea	DEZIGN+18,a0	
	move.l	a0,a1
	move.l	LOG,a5
	move.l	a5,a6
	move.w	X_PLAQUE,d7
	lea	(a5,d7.w*2),a5
	lea	(a0,d7.w*2),a0
	move.w	Y_PLAQUE,d6
	muls	#768,d6
	add.l	d6,a6
        add.l	d6,a6
	add.l	d6,a1
	move.w	Y_PLAQUE,d7
	subq.w	#1,d7
	bmi.s	.C
.X	move.w	(a0)+,(a5)+
	add.w	#768-2,a0
	add.w	#768*2-2,a5
	dbra	d7,.X
.C	
	move.w	X_PLAQUE,d7
	;subq	#1,d7
	bmi.s	.C2
.Y	
	move.w	(a1)+,(a6)+
	dbra	d7,.Y
.C2
	subq.w	#1,X_PLAQUE
	tst	X_PLAQUE
	bge.s	.OK
	addq.l	#4,sp
	rts
		
.OK	move.l	#256*65536/384,d0
	sub.l	d0,Y_PLAQUE
	rts

	
PLAQUE
	move.l	LOG,a6
	move.w	X_PLAQUE,d7
	lea	(a6,d7.w*2),a6
	move.w	Y_PLAQUE,d6
	muls	#768*2,d6
	add.l	d6,a6
	move.l	a6,a5
	moveq	#-1,d0
	move.w	#384,d7
	sub.w	X_PLAQUE,d7
	subq.w	#1,d7
.X	
	move.w	d0,(a5)+
	dbra	d7,.X
	move.w	#256,d7
	sub.w	Y_PLAQUE,d7
	subq.w	#1,d7
.Y	
	move.w	d0,(a6)+
	add.w	#768*2-2,a6
	dbra	d7,.Y

	subq.w	#1,X_PLAQUE
	tst	X_PLAQUE
	bge.s	.OK
	addq.w	#1,X_PLAQUE
	move.l	#383*65536,X_PLAQUE
	move.l	#255*65536,Y_PLAQUE
	addq.l	#4,sp
	rts
	
	
.OK	move.l	#256*65536/384,d0
	sub.l	d0,Y_PLAQUE
	rts
	

GRAF_SCREEN_2
	lea	$ffffa204.w,a6
	lea cos_table,a4
	lea sin_table,a5
	move.w	ANGLE_X,d2
	and.w	#511,d2
	move.w	(a4,d2.w*2),d0
	move.w	(a5,d2.w*2),d1
	ext.l	d0
	ext.l	d1
	muls.w	zoom_x,d0
	asr.l	#8,d0
	muls.w	zoom_x,d1
	asr.l	#8,d1
	lea	$ffffa204.w,a6
	env	
	move.l	d0,(a6)		;ix
	move.l	d1,(a6)		;iy
	neg.l	d1
	move.l	d1,(a6)		;ix
	move.l	d0,(a6)		;iy
	asr.l	#8,d0
	asr.l	#8,d1
	asr.l	#1,d0
	asr.l	#2,d1
	move.l	d1,(a6)		;ix
	move.l	d0,(a6)		;iy

TOTO
	lea	$ffffa206.w,a6
	move.l	LOG,a0
	;add.l	#112*2+768*2*40,a0
	add.l	#37*2+768*2*40,a0
	move.w	#160-1,d7

Y_BOU	
	move	#(80)-1,d6
	rec
EN_X
	move.w	(a6),(a0)+
	move.w	(a6),(a0)+
	dbra	d6,EN_X
	add.w	#768*2-160*2,a0
	dbra	d7,Y_BOU

	
	move.l	alea_ptr,a0
	move.w	(a0),d0
	cmp.w	#$9876,d0
	bne.s	OK_ALEAT
	lea	aleat,a0
	move.l	script_ptr,a1
	move.l	(a1)+,d0
	bmi.s	.OK
	move.l	a1,script_ptr
	move.l	d0,ima_ptr
	bra.s	OK_ALEAT

.OK	st	TRANS
		
OK_ALEAT
	;clr.w	-2(a6)
	moveq	#0,d0
	move.l	ima_ptr,a1
	move.w	#512-1,d7
.F	
	env
	move.w	(a0)+,d0
	move.w	d0,(a6)
	move.w	(a1,d0.l*2),(a6)
	dbra	d7,.F
	move.l	a0,alea_ptr
	rts


VBL
	trap	#3
	addq.l	#$1,$200.w
	movem.l	d0-a6,-(sp)

	move.l	LOG,d0
	tst	TRANS
	beq.s	NOK
	tst.b	$208.w
	beq.s	nok
	move.l	amort_ptr,a0
	moveq	#0,d1
	move.w	(a0)+,d1
	bpl.s	.C
	st	FLAG_FIN
	subq.l	#4,a0
	moveq	#0,d1	
	move.w	(a0)+,d1
	move.w	#384,d1
.C	
	move.l	a0,amort_ptr
	add	d1,d1
	add.l	d1,d0
NOK
	lea	$ffff8200.w,a0
	move.b	d0,d1
	lsr.l	#8,d0
	movep.w	d0,1(a0)
	move.b	d1,$d(a0)
	
	move.w	#384,$ffff820e.w
	addq.l	#1,$466.w
	tst	TRK
	beq.s	.NO
	trap	#4
.NO	
	;cmp.b	#$39,$fffffc02.w
;	bne.s	P_FIN
;	jmp	FIN
P_FIN
	movem.l	(sp)+,d0-a6
	rte
	


	
RESERVE_ECRANS
	move.l	#LOG_BUF+256,d0
	sf	d0
	move.l	d0,LOG
	move.l	d0,a0

	move.l	#PHYS_BUF+256,d0
	sf	d0
	move.l	d0,PHYS
	move.l	d0,a1

	move.l	$42e.w,a2
	sub.l	#768*264,a2
	lea	IMG+18,a3
	
	move.w	#256-1,d7

.Y	move.w	#192-1,d6
.X1	move.l	(a2),(a0)+
	move.l	(a2)+,(a1)+
	dbra	d6,.X1
	move.w	#15,d6
.ER0	clr.l	(a0)+
	clr.l	(a1)+
	dbra	d6,.ER0
	move.w	#160-1,d6
.X2	move.l	(a3),(a0)+
	move.l	(a3)+,(a1)+
	dbra	d6,.X2
	move.w	#15,d6
.ER1	clr.l	(a0)+
	clr.l	(a1)+
	dbra	d6,.ER1

	dbra	d7,.Y

CO
	lea	$ffffa206.w,a6
	env
	clr.w	-2(a6)	
	move.w	#64-1,d7
.Y	move.w	#128-1,d6
.X	env
	move.w	#$6,(a6)
	dbra	d6,.X
	dbra	d7,.Y
	rts
	
	incdir d:\sources\
	
	SECTION TEXT
	include	'FALC_INT.S'
	SECTION TEXT

load_dsp_prog
	lea	dsp_rout,a0			;Adresse et taille de notre
	move.w	#dsp_size/3,d0			;programme exemple au !! DSP !!.
	jsr	(pload_dsp_prg,[$40c+4+4.w])		;charge le prog DSP
	rts

	
FIN
	move.l	old_pile,a7
	move.l	(sp)+,$70.w
	move.w	#$2300,sr

	lea	IMG+18,a0
	move.l	$42e.w,a1
	sub.l	#640*256,a1
	move.l	a1,d0
	move.w	#255,d7
.Y	move.w	#160-1,d6
.X	move.l	(a0)+,(a1)+
	dbra	d6,.X
	dbra	d7,.Y

	vsync
	aset_screen	d0
	aset_video	#5
	vsync
	rts
FLAG_FIN	dc.w	0
	
	SECTION DATA
TRK		dc.w	0
TRANS		dc.w	0
IMG		incbin	juanita.tg1

script_ptr	dc.l	script
script	
		;dc.l	16384

	dc.L	0,0,0,1,2,3,4,5,6,7,8
	dc.l	9,9,9,10,11,12,13,14,15,16,17
	dc.l	18,18,18,18,18,18,18,18,19,20,21,22,23,24,25,26
	dc.l	27,27,27
	dc.l	-1

ima_ptr		dc.l	ima
ima		
		incbin	roto.dat
		incbin	roto2.dat
fimg

dsp_rout	incbin	love3.P56
dsp_size	equ	*-dsp_rout
		even

cos_table
sin_table	equ cos_table+1024
		incbin	cosin.dat

X_PLAQUE	dc	383,0
Y_PLAQUE	dc	255,0

ANGLE_X		dc.w	0,0
zoom_X		dc.w	256,0
;zoom_Y		dc.w	256,0
IX		dc.l	1
IY		dc.l	-1
DEZIGN		incbin	celtic2.TG1
		ds.w	32*320

alea_ptr	dc.l	aleat
ALEAT		incbin	aleat.dat
		dc.w	$9876

amort_ptr	dc.l	amort
AMORT		incbin	amort.dat
		dc.w	-1,-1
	SECTION	BSS
CPT		ds.W	1
SAVE_MODE	ds.w	1
old_pile	ds.l	1
SAVE_SSP	ds.l	1
SAVE_BUS	ds.l	1
SAVE_ILL	ds.l	1
SAVE_ADR	ds.l	1
LOG		ds.l	1
PHYS		ds.l	1
LOG_BUF		ds.w	256+768*256
PHYS_BUF	ds.w	256+768*256
END_T		



