  data
fileprompt:             ; prompt for filename
  dc.b 'Please enter the filename (& pathname if needed) of the',10,13,0
picture:
  DC.B 'picture file to extract the characters from.',13,10,0
characters:
  dc.b 'file to output the characters to.',10,13,0
reading:
  dc.b 10,13,'Loading picture. ',10,13,0
converting:
  dc.b 'Converting image to characters.',10,13,10,0
saveing:
  dc.b 10,13,'Saving characters. ',10,13,10,0

input:                  ; adress of input string
  dc.b 64,0
filespec:               ; actual string begins here
  ds.b 64

  bss
handle:                 ; space for file handle
  ds.w 1
BUFFER:
  DS.w 1                ; res value
pal:
  ds.w 16               ; palette
bitmap:                 ; image
  ds.b 32000
chars                   ; converted data
  ds.b 32000

  text
  move.l #fileprompt,d0 ; prompt for filename input
  jsr prtline
  move.l #picture,d0
  jsr prtline

  move.l #input,-(sp)   ; input filename
  move #$a,-(sp)
  trap #1
  addq.l #6,sp

  lea filespec,a0
  move.b #0,(a0,d0.w)   ; null terminate the string

  move #2,-(sp)         ; open file
  move.l #filespec,-(sp)
  move #$3d,-(sp)
  trap #1
  addq.l #8,sp
  move d0,handle

  move.l #reading,d0    ; inform reading
  jsr prtline

  move.l #buffer,-(sp)  ; read
  move.l #32034,-(sp)
  move handle,-(sp)
  move #$3f,-(sp)
  trap #1
  add.l #12,sp

  move handle,-(sp)     ; close file
  move #$3e,-(sp)
  trap #1
  addq.l #6,sp

  move.l #converting,d0 ; inform user of conversion process
  jsr prtline

  lea bitmap,a0         ; from
  lea chars,a1          ; to
  move #12-1,d7         ; rows
nextrow:
  move #20-1,d6         ; columns
nextcol:
  move #16-1,d5         ; lines per char
nextlineinchar:
  move.l 0(a0),(a1)+    ; copy data
  move.l 4(a0),(a1)+
  add #160,a0           ; next line
  dbra d5,nextlineinchar
  sub #160*16-8,a0      ; next column
  dbra d6,nextcol
  add #160*15,a0        ; next row
  dbra d0,nextrow

  move.l #fileprompt,d0 ; prompt for filename output
  jsr prtline
  move.l #characters,d0
  jsr prtline

  move.l #input,-(sp)   ; input filename
  move #$a,-(sp)
  trap #1
  addq.l #6,sp

  lea filespec,a0
  move.b #0,(a0,d0.w)   ; null terminate the string

  move #0,-(sp)         ; create file
  move.l #filespec,-(sp)
  move #$3c,-(sp)
  trap #1
  addq.l #8,sp
  move d0,handle

  move.l #saveing,d0    ; inform saveing
  jsr prtline

  move.l #chars,-(sp)  ; save
  move.l #16*8*20*12,-(sp)
  move handle,-(sp)
  move #$40,-(sp)
  trap #1
  add.l #12,sp

  move handle,-(sp)     ; close file
  move #$3e,-(sp)
  trap #1
  addq.l #6,sp

  clr -(sp)             ; term
  trap #1

; ***** subroutines *****

prtline:
  move.l d0,-(sp)
  move #$09,-(sp)
  trap #1
  addq.l #6,sp
  rts

  end
 