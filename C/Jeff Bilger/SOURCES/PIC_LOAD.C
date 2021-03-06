/* load up a compressed degas elite pic */
#include <osbind.h>
#define REZ 1                    /* 1 med, 0 low */
#define rnd(t) Random()%(t)   /*returns a number from 0 to (t-1) */

char	 temp_[32000],		             /* Temp buffer where file is read in	*/
         *hld,
		 *iff_in, *iff_out;	              /* Pointers for DEGAS unpack() routine	*/

#include <stdio.h>
int contrl[12];
int intin[256],  ptsin[256];
int intout[256], ptsout[256];

char title[] ="Revenge.pc2";
int savepal[16],newpal[16],junkbuff[46],pal2[16];
int filehandle;
main()

{
   
    char *scr1,*kill2,*screen;
    int handle,x,kill1;
    
     
   scr1 = malloc(32768+256);  /*allocate memory for 2nd screen */
    if ((long) scr1 & 0xff)
      scr1 = scr1 + (0x100 - (long)scr1 & 0xff);
screen = (char *)Physbase();
read_stuff(title,scr1,1);  /* read main title screen onto the temp scr*/
Setscreen(screen,scr1,-1);
Setpalette(newpal);        /* tel sys to use these colors! */


 do
     {
    ; /* nothing */
     } while ( !Bconstat(2));      /* while no input */
     

/*
x=0;
 do                  destroy pic! cool!! 
  {
   kill1 = rnd(32760);
   kill2 = kill1+scr1;
   *kill2=0; 
  } while (x++ < 32766);*/
Setscreen(screen,screen,-1);  
Setpalette(savepal);      /* restore palette */

}

/* load degas compressed pics */

/************************/
read_stuff(hold,adrr,which)
char hold[];
register char *adrr;
int which;  
/* if which = 1 then store palette into newpal*/
/* which is the main pal of the game. If = 0 then store */
/* into pal2. the alternate pal of the game */

{
 char buf[130];
 int lines,i;
 
 /*v_gtext(handle,1,5,"in read stuff");*/

filehandle = Fopen(hold,0); 

for(i=0; i<16;i++)
 savepal[i]=Setcolor(i,-1);
/* read header data */
i=Fread(filehandle,2L,buf);


/* read 16 words of palette data into newpal array */
if(which==0) i = Fread(filehandle,32L,pal2); /* save pal2 */
else
i =Fread(filehandle,32L,newpal);
 

 

i=Fread(filehandle,32000L,temp_);  /* read image onto back screen*/
/* Close file */
Fclose(filehandle);
	 lines = 200;		             /* Low, med-res	*/
				 iff_in  = temp_;                /* iff_in pts to temp_buf*/
			     iff_out = adrr;      /* iff_out pts to pic_buffer*/
			      do		
         unpack(REZ);			                          /* Unpack a line at a time */
			      while (--lines); 


 /*v_gtext(handle,1,5,"             ");*/
       
}
/************************/

/***********************/

/*---------------------------------------------------------------------------*/
/*					         |--------- DEGAS ---------|			*/
/*					          UNCOMPRESSED   COMPRESSED			*/
/*			     NEO  low med mono   low med mono	 TINY	*/
/*	typ...		0     1   2   3     4   5   6     7		*/

/* Unpacks a single scan line & updates iff_in & iff_out global pointers

                     /	byt ==  0 to  127  copy next [byt+1] bytes
Unpack routine --if-<	byt == -1 to -127  copy next byte [-byt+1] times
                     \	byt == 128         NO-OP							*/

unpack(rez)
int	 rez;

{
	register char	 *src_ptr, *dst_ptr,           /* ptrs to source/dest */
              byt, cnt;                     /* byt holds the ACTUAL compressed data code(control byte ) */
	register int	  minus128 = -128, 
              len;                          
	char			     linbuf[320];		                    /* Oversize just in case! */
	int				      llen;


	if (rez < 2)	 len = 160;
	else			 len = 80;
	llen = len;
	src_ptr = iff_in;           /* iff_in is ptr to compressed data */
	dst_ptr = &linbuf[0];       /* linbuf WILL hold an ENTIRE Uncompressed scan line. 4 bitplanes * 80 = 320 max! */ 

	while (len > 0)
   {
		    byt = *src_ptr++;       /* get byte value at address scr_ptr, THEN inc scr_ptr+1 */
		    if (byt >= 0)           /* If ctrl code >= 0 then use the next x+1 bytes*/
    {
			     ++byt;                 /* inc byt +1 */
			      do 
       {
				        *dst_ptr++ = *src_ptr++;  /* get byte value from address source, and inc the 2 ptrs */
				        --len;                    /* one byte down.. */
			       }
         while (--byt);           /* do this byt TIMES (remember byt here = byt+1 */
		     }
		     else 
       if (byt != minus128)       /* else if ctrl code NOT = -128*/
         {                        /*Then use the next byte -x+1 times, (-x) cause x will be negative and - - = + */
			          cnt = -byt + 1;         /* cnt = -x + 1 */
			          byt = *src_ptr++;       /* byt = THE very next byte past the ctrl code(or ctrl byte! */
			           do {
				               *dst_ptr++ = byt;  /* store that byte */
				               --len;         
			              }
               while (--cnt);    /* keep doing it cnt times */
		          }
	    }

	ilbm_st(linbuf, iff_out, rez);   /* convert the format line */
	iff_in = src_ptr;					                /* Update global pointers */
	iff_out += llen;

}                                /* end of module uncompress() */

/*---------------------------------------------------------------------------*/

ilbm_st(src_ptr, dst_ptr, rez)		   /* Convert ILBM format line to ST format */
int		 *src_ptr, *dst_ptr, rez;
{
	int		 x, *p0_ptr, *p1_ptr, *p2_ptr, *p3_ptr;

	if (rez==0) 
 {				                                     /* Low-res */
  
		p0_ptr = src_ptr;
		p1_ptr = src_ptr + 20;
		p2_ptr = src_ptr + 40;
		p3_ptr = src_ptr + 60;
		for (x=0; x<20; ++x)
  {
			   *dst_ptr++ = *p0_ptr++;
			   *dst_ptr++ = *p1_ptr++;
			   *dst_ptr++ = *p2_ptr++;
			   *dst_ptr++ = *p3_ptr++;
		  }
	} 
 else if (rez==1) 
  {		                                    /* Med-res */
		   p0_ptr = src_ptr;
		   p1_ptr = src_ptr + 40;
		   for (x=0; x<40; ++x)
    {
			     *dst_ptr++ = *p0_ptr++;
			     *dst_ptr++ = *p1_ptr++;
		    }
	}
    else 
     {					                               /* Monochrome */
		      for (x=0; x<40; ++x)
			      *dst_ptr++ = *src_ptr++;
	     }
 
 }
/*---------------------------------------------------------------------------*/

