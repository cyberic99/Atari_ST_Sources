***************************************************************************
*							    *
*   STFM Overscan 	    - Source code (c) Diamond Software 1994	    *
*   Original Overscan   - Neil (Powerman of TWB - The Wild Boys)          *
*   New Source Code     - Steven J				    *
*   Font Graphics	    - ????				    *
*							    *
*		    - Set your tabs to 10			    *
*		    - Assemble with GENST V2+ 		    *
*		    - Does not work on STEs (Thanks Nik B!)	    *
*							    *
* The left & right border removing routines are controled by Timer B.     *
* This means that you don't have to clock cycle you routine in the vbl,   *
* but it does means that graphics will be distorted! (put you routine in  *
* the vbl)						    *
*							    *
* This version only draw a picture and plays some music. The upper and    *
* lower border and switched off but I did'nt put anything in them!        *
***************************************************************************

scan1	equ	160		left & right borders on
scan2	equ	230		left & right borders off
scan3	equ	180		left or right border off

	bsr	setup		setup picture, screen etc
mainloop	cmp.b	#57,$fffffc02	is space pressed?...
	bne	mainloop		no. keep looping
	bra	exit		yes, quit

***************************************************************************
* EXIT						  	    *
* Restore all that was changed				    *
***************************************************************************

exit	
	bsr	mfp_off		restore old interupts
	bsr	stop_music	stop the music playing
	move.b	#2,$fff820a
	move.w	oldres,-(sp)	set old resolution
	move.l	oldscr,-(sp)	set old physical screen address
	move.l	oldscr,-(sp)	set old logical screen address
	move.w	#5,-(sp)		set screen
	trap	#14		call xbios
	add.l	12,sp		adjust stack

	bsr       resetoldpal    	reset the old palette

	move.l	#mon,-(sp)	mouse on
	clr.w	-(sp)		keep old
	move.w	#25,-(sp)		
	trap	#14		call xbios
	addq.l	#8,sp		adjust the stack

	move.l    oldsp,-(sp)         reset old stack address
	move.w    #32,-(sp) 	set in supervisor mode 
	trap      #1        	call gemdos
	addq.l    #6,sp     	adjust the stack

	clr.l     -(sp)     	quit
	trap	#1		

***************************************************************************
* SETUP						  	    *
* Setup the screens, resolution, picture etc...			    *
***************************************************************************
	
setup	
	clr.l     -(sp)		keep old stack
	move.w    #32,-(sp)		call supervisor
	trap      #1		call gemdos
	addq.l    #6,sp		adjust the stack
	move.l    d0,oldsp		save old supervisor

	bsr	setscreen		setup the screens and res
	bsr	mouse_off		turn the mouse off
	bsr	start_music	setup the music
	bsr	savepal		save and set the palette
	bsr	draw_backgrnd	draw the full screen ictari picture
	bsr	mfp_on		save and install interupts
	
	rts

***************************************************************************
* SETUP THE SCREENS AND RESOLUTION IF WE CAN		  	    *
***************************************************************************

setscreen	
	move.w	#4,-(sp)		get screen res
	trap	#14		call xbios
	addq.l	#2,sp		adjust stack
	cmp.b	#2,d0		are we in high res?
	beq	high		yes, quit
	move.w	d0,oldres		save old res

	move.w	#3,-(sp)		get screen address
	trap	#14		call xbios
	add.l	#2,sp		adjust stack
	move.l	d0,oldscr		save old screen

	move.l	#screens,d0
	clr.b	d0
	move.l	d0,screen
	move.l	d0,d1
	add.l	#64000,d1
	eor.l	d0,d1
	move.l	d1,scr_xor

	move.w	#0,-(sp)		low resolution
	move.l	screen,-(sp)	physical screen address
	move.l	screen,-(sp)	logical screen address
	move.w	#5,-(sp)		set screen
	trap	#14		call xbios
	add.l	#12,sp		adjust stack

	move.l	#screen,a6	
	move.l	(a6),d6		
	move.l	d6,4(a6)		
	move.l	scr_xor,d0	
	eor.l	d0,d6		
	move.l	d6,screen		
	lsr.l	#8,d6		
	move.l	#$ffff8201,a5	 
	movep.w	d6,(a5)		
	
	rts

***************************************************************************
* WE'RE IN HIGH REZ					 	    *
***************************************************************************

high
	move.l	#high_mess,-(sp)	get the high res message
	move.w	#9,-(sp)		print it to the screen
	trap	#1		gemdos
	add.l	#6,sp		restore stack

	move.w	#8,-(sp)		wait for a key
	trap	#1		gemdos
	add.l	#2,sp		restore stack

	clr.l	-(sp)		quit
	trap	#1		gemdos

***************************************************************************
* SETUP THE MUS TO PLAY				 	    *
***************************************************************************

start_music
	move	#1,d3		min music number
	move	#9,d4		max music number
	bsr	random		random music number!
	jsr	music		setup the music

	rts

***************************************************************************
* STOP THE MUSIC					 	    *
***************************************************************************

stop_music
	moveq	#0,d0		music no. 0
	jsr	music		set music

	move.b	#8,$ffff8800	chanel A
	clr.b	$ffff8802		no volume
	move.b	#9,$ffff8800	chanel B
	clr.b	$ffff8802		no volume
	move.b	#10,$ffff8800	chanel C
	clr.b	$ffff8802		no volume

	rts	

***************************************************************************
* TURN THE MOUSE OFF				 	    *
***************************************************************************

mouse_off	
	move.l	#moff,-(sp)	mouse off
	clr.w	-(sp)		keep old
	move.w	#25,-(sp)		
	trap	#14		call xbios
	addq.l	#8,sp		adjust the stack

	rts			

***************************************************************************
* RESET OLD PALETTE                                                       *
***************************************************************************

resetoldpal  
	movem.l	oldpal,d0-d7	get our old palette
	movem.l	d0-d7,$ffff8240	set it

	rts

***************************************************************************
* SAVE THE PALETTE 						    *                                                       *
***************************************************************************

savepal
	movem.l   $ffff8240,d0-d7     get entire palette
          movem.l   d0-d7,oldpal      	save palette

	movem.l	pal1,d0-d7	get new palette
	movem.l	d0-d7,$fff8240	set palette
	
	rts			

***************************************************************************
* RANDOM NUMBER 						    *                                                       *
* d3=min / d4=max / d0=result					    *
***************************************************************************

random	
	addq.l	#1,d4		
	move.w	#17,-(a7)		
	trap	#14		
	addq.w	#2,a7		
	and.l	#$ffff,d0		
	sub.l	d3,d4		
	divu	d4,d0		
	swap	d0		
	and.l	#$ffff,d0		
	add.l	d3,d0		

	rts

***************************************************************************
* SAVE AND INSTALL INTERUPTS 					    *
***************************************************************************

mfp_on:	move.l  	$120,oldtb	save old timer B vector
	move.l  	$70,old4		save old vb vector
	move.l  	$134,oldtimera	old timer A
	move.b  	$fffffa07,old07	timer B enable
	move.b  	$fffffa09,old09	timer C enable
	move.b  	$fffffa0f,old0f	timer B in-service
	move.b  	$fffffa11,old11	timer C in-service
	move.b  	$fffffa1b,old1b	timer B control
	and.b   	#$df,$fffa09	disable timer C
	and.b   	#$fe,$fffa07	disable timer B 
          move.b    $fffffa07,timera1   interupt enable a
          move.b    $fffffa13,timera2   interupt mask a
          move.b    $fffffa19,timera3   timer a control
          move.b    $fffffa1f,timera4   timer a data
          clr.b     $fffffa19 	empty timer a data
          move.b    #$21,$fffffa07      disable interupt a
          move.b    #$21,$fffffa13      set mask a
          bclr      #3,$fffffa17        reset vector base
          move.l    #topbord,$134       put top border rout in timer a
	move.l  	#new_vbl,$70	new vb vector
	move.l	#left_n_right,$120	new timer B 
	or.b    	#1,$fffffa07	enable timer B
	or.b    	#1,$fffffa13	set timer B mask
	rts

***************************************************************************
* RESET INTERUPTS                                                         *
***************************************************************************

mfp_off: 	move.w  	sr,-(sp)		save 
	move.w  	#$2700,sr		cut out all interrupts
	move.b  	old07,$fffffa07 	restore all old vectors
	move.b  	old09,$fffffa09	timer c enable
	move.b  	old0f,$fffffa0f	timer b in-service
	move.b  	old11,$fffffa11	timer c in-service
	move.b  	old1b,$fffffa1b	timer b control
          move.b    timera1,$fffffa07   interupt enable a
          move.b    timera2,$fffffa13   interupt mask a
          move.b    timera3,$fffffa19   timer a control
          move.b    timera4,$fffffa1f   timer a data
          move.l    oldtimera,$134      timer a interupt
	move.l  	oldtb,$120	old timer b
	move.l  	old4,$70		old vbl
	move.w  	(sp)+,sr		retore
	rts			return

***************************************************************************
* VBLANK ROUTINE                                                          *
* BSR / BSR.S and JSR takes a massive 36 cycles!! - don't use them!	    *
***************************************************************************

new_vbl	
	clr.b	$fffffa19 	stop timer A...
	move.b	#100,$fffffa1f      set data
          move.l    #topbord,$134       top border rout.
	move.b	#4,$fffffa19        start timer A again

	clr.b	$fffffa1b 	stop timer b
	move.b	#7,$fffffa21 	scan line
	move.l	#left_n_right,$120  timer B rout
	move.b 	#8,$fffffa1b        start timer B agian	

	jsr	music+8		play music

	rte

***************************************************************************
* REMOVE THE LEFT AND RIGHT BORDER				    *
* Routine adapted from Powerman. Now uses less registers and time.	    *
***************************************************************************

left_n_right
	clr.b	$fffffa1b		stop timer B
	move.w	#$2700,sr		cut out all interupts
	move.l	#$ffff8209,a0    	lowbyte of video address counter
	move.l	#$fffffa21,a1	timer b data (i.e. scanline)
	moveq.w	#0,d0		clear register
	moveq.w	#0,d1		clear register
	moveq.w	#16,d2		delay

	move.b	#10,(a1)		scanline
	move.b	#8,$fffffa1b.w	start timer b
	move.b	(a1),d3		get scanline
.l1	cmp.b	(a1),d3		are we at the start of it?
	beq	.l1		no, keep on trying
.l2	move.b	(a0),d0		make sure we start on right line
	beq.s	.l2		if not, keep trying
	sub.w	d0,d2		sub start from delay
	lsl.w	d2,d0		get correct amount of cycles
	clr.b	$fffffa1b.w	stop time b
	dcb.w	84,$4e71		wait until we're in the border

	lea	$ffff820a.w,a0	synchronisation mode (Hz)
	lea	$ffff8260.w,a1    	picture resolution
	moveq.w	#2,d1		high res/50Hz
	moveq.w	#0,d2		low res/60Hz

	move.w	#219-1,d0		set number lines to overscan
.lines1	move.b	d1,(a1)		set high res
	move.b	d2,(a1)		set low res
	dcb.w	89,$4e71		move into the right border
	move.b	d2,(a0)		set 60Hz
	move.b	d1,(a0)		set 50Hz
	dcb.w	13,$4e71		move into far right/left border
	move.b	d1,(a1)		set high res
	nop			pause for 4 cycles
	move.b	d2,(a1)		set low res
	dcb.w	10,$4e71		move into the left border
	dbf	d0,.lines1	end of repeat

;>> Bottom border removing routine - took ages to time this!

	move.b	d1,(a1)		set high res
	move.b	d2,(a1)		set low res
	dcb.w	88,$4e71		move into the border

	move.b	d2,(a0)		set 60Hz
	move.b	d1,(a0)		set 50Hz
	dcb.w	12,$4e71		small delay
	move.b	d2,(a0)		set 60Hz
	move.b	d1,(a1)		set high res
	nop			pause for 4 cycles
	move.b	d2,(a1)		set low res
	moveq.w	#45-1,d0		no. lines in the bottom border
	dcb.w	9,$4e71		pause
	move.b	d1,(a0)		set 50hz

.no_lines2
	move.b	d1,(a1)		set high res
	move.b	d2,(a1)		set low res
	dcb.w	89,$4e71		move into the border
	move.b	d2,(a0)		set 60Hz
	move.b	d1,(a0)		set 50Hz
	dcb.w	13,$4e71		small delay
	move.b	d1,(a1)		set high res
	nop			wait for 4 cycles
	move.b	d2,(a1)		set low res
	dcb.w	10,$4e71		move into the border
	dbf	d0,.no_lines2	keep overscaning the scanline

	bclr	#0,$ffffa0f
	rte

***************************************************************************
* TOP BORDER REMOVING ROUTINE - REMOVES 28 SCANLINES		    *
***************************************************************************

topbord   
	move.w    #$2100,sr 	set status register
          stop      #$2100    	wait for interupt
          clr.b     $fffffa19 	disable timer a
	dcb.w	78,$4e71		wait until we're in the border
          clr.b     $ffff820a 	change to 60HZ
	dcb.w	2,$4e71		pause for hertz delay
          move.b    #2,$ffff820a        set it back to 50hz. NO TOP BORDER
          rte                 	return from interupt

***************************************************************************
* DRAW THE BACKGROUND 					    *
* Don't use this drawing routine because it's too slow in main loops!!!!! *
***************************************************************************

draw_back1
	move	#210-1,d1		lines
dl1
i	set	0		set to 0
	rept	25		repeat chunks (1 chunk=16 pixels)
	move.l	i(a2),i(a0)	copy 1st half of a chunk (logical)
	move.l	i+4(a2),i+4(a0)	copy 2nd half a chunk (logical)
i	set	i+8		next chunk
	endr			end of copying chunks
	add.l	#scan2,a0		next scanline line for logical
	add.l	#scan2,a2		next scanline line for piccy
	dbf	d1,dl1		end of copying lines

	rts

***************************************************************************
* DRAW THE PICTURE						    *
***************************************************************************

draw_backgrnd

	move.l	#name1,a2		copy our names
	add.l	#160*9,a2
	move.l	screen,a0		
	add.l	#160*9,a0		
	add.l	#230*9,a0
	jsr	draw_back1

	rts

***************************************************************************

name1	incbin	"a:\assembly\overscan\diamond.dso"
music	incbin	"a:\assembly\overscan\gallery.mus"

pal1	dc.w	$0000,$0211,$0211,$0321,$0332,$0433,$0443,$05C4
	dc.w	$0555,$0665,$0666,$0777,$0210,$0200,$0100,$0777

high_mess	dc.b	27,"E",27,"p"	cls, inverse on
	dc.b	"Sorry but this program needs more than two colours..."
	dc.b	27,"q",0		inverse off, null
	even
mon	dc.b    	8		code for mouse on
moff	dc.b    	18		code for mouse off
old4	dc.l	0		old interupts
oldtb	dc.l	0
old07	dc.b	0
old09	dc.b	0
old0f	dc.b	0
old11	dc.b	0
old1b	dc.b	0
oldtimera	dc.l	0
timera1	dc.l	0
timera2	dc.l	0
timera3	dc.l	0
timera4	dc.l	0

	section bss

oldres	ds.b	2		old resolution
oldscr	ds.l	4		old screen address
oldpal	ds.b	32		old palette
screen	ds.l	1		drawing scr
	ds.l	1
scr_xor	ds.l	1
oldsp    	ds.l	1		old stack pointer
	ds.l	100	
screens	ds.b	64000		space for physical screen
	ds.b	64000		space for logical

