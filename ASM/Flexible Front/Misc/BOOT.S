; MOVE.W #1,-(SP)
; MOVE.W #2,-(SP)
; MOVE.W #-1,-(SP)
; PEA BOOT1
; MOVE.W #18,-(SP)
; TRAP #14
; ADD.L #14,SP

 LEA BOOT1,A0
 CLR.W D0
 MOVE.W #$FF,D1
BT1:
 ADD.W (A0)+,D0
 DBRA D1,BT1
 MOVE.W #$1234,D1
 SUB.W D0,D1
 MOVE.W D1,BOOT1+510

 MOVE.W #1,-(SP)
 MOVE.W #0,-(SP)
 MOVE.W #0,-(SP)
 MOVE.W #1,-(SP)
 MOVE.W #0,-(SP)
 CLR.L -(SP)
 PEA BOOT1
 MOVE.W #9,-(SP)
 TRAP #14
 ADD.L #20,SP
 ILLEGAL
BOOT1:
 BRA.S ROUT
 DS.B 9
 DC.B 0,2,2,1,0,2,$70,0,$D9,02,$F8,5,0,9,0,1,0,0,0
ROUT:
 MOVE.W #$2700,SR
 CLR.W $FF8240
 CLR.L $24
 MOVE.L #49000,SP
 MOVE.L #450000,-(SP)
 MOVE.L #40000,-(SP)
 CLR.W -(SP)
 MOVE.W #$4A,-(SP)
 TRAP #1
 ADD.L #12,SP
 MOVE.W #2,-(SP)
 CLR.W -(SP)
 MOVE.W #0,-(SP)
 MOVE.W #8,-(SP)
 MOVE.W #0,-(SP)
 CLR.L -(SP)
 MOVE.L #50000,-(SP)
 MOVE.W #8,-(SP)
 TRAP #14
 ADD.L #20,SP
 MOVE.W #$2700,SR
 LEA 50004,A0
 MOVE.W #254,D0
DCRY:
 EOR.L #'ZZAP',(A0)+
 DBRA D0,DCRY
 JMP 50000
 DS.W 200
 END

 