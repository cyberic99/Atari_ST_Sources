	MOVEQ	#0,D6		;MAX
	LEA	SIN,A6
	MOVEQ	#17-1,D7
MAIN:
	MOVE.L	A6,A0
	MOVEQ	#26-4-1,D5
SUBD:
	CLR	D0
	MOVE.B	(A0),D0
	SUB.B	1(A0),D0
	BPL.S	ABS
	NEG.B	D0
ABS:
	CMP	D6,D0
	BLS.S	MIN
	MOVE	D0,D6
	CMP	#4,D6
	BNE.S	MIN
	ILLEGAL

MIN:
	ADDQ	#1,A0
	DBRA	D5,SUBD

	LEA	26(A6),A6
	DBRA	D7,MAIN
	ILLEGAL
SIN:
 dc.b 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 dc.b 0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,1,1,1,1,1,1,0,0,0,0
 dc.b 0,0,1,1,2,2,2,3,3,3,3,4,4,4,4,3,3,3,3,2,2,2,1,1,0,0
 dc.b 0,0,1,2,2,3,4,4,5,5,5,5,6,6,5,5,5,5,4,4,3,2,2,1,0,0
 dc.b 0,1,2,3,3,4,5,6,6,7,7,7,8,8,7,7,7,6,6,5,4,3,3,2,1,0
 dc.b 0,1,2,3,4,5,6,7,8,9,9,9,10,10,9,9,9,8,7,6,5,4,3,2,1,0
 dc.b 0,1,3,4,5,7,8,9,10,10,11,11,12,12,11,11,10,10,9,8,7,5,4,3,1,0
 dc.b 0,1,3,5,6,8,9,10,11,12,13,13,14,14,13,13,12,11,10,9,8,6,5,3,1,0
 dc.b 0,2,4,5,7,9,11,12,13,14,15,15,16,16,15,15,14,13,12,11,9,7,5,4,2,0
 dc.b 0,2,4,6,8,10,12,13,15,16,17,17,18,18,17,17,16,15,13,12,10,8,6,4,2,0
 dc.b 0,2,5,7,9,11,13,15,16,18,19,19,20,20,19,19,18,16,15,13,11,9,7,5,2,0
 dc.b 0,2,5,8,10,13,15,17,18,20,21,21,22,22,21,21,20,18,17,15,13,10,8,5,2,0
 dc.b 0,3,6,8,11,14,16,18,20,21,22,23,24,24,23,22,21,20,18,16,14,11,8,6,3,0
 dc.b 0,3,6,9,12,15,17,20,22,23,24,25,26,26,25,24,23,22,20,17,15,12,9,6,3,0
 dc.b 0,3,7,10,13,16,19,21,23,25,26,27,28,28,27,26,25,23,21,19,16,13,10,7,3,0
 dc.b 0,3,7,11,14,17,20,23,25,27,28,29,30,30,29,28,27,25,23,20,17,14,11,7,3,0
 dc.b 0,4,8,11,15,18,22,24,27,29,30,31,32,32,31,30,29,27,24,22,18,15,11,8,4,0
