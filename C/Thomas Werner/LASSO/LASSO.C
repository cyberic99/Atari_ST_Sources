/*----------------------------------------------------------------*/
/*                    LASSO-FUNCTION                              */
/*                                                                */
/* Original routine in OMIKRON.BASIC: L. Canisius                 */
/* C-Convertion: Thomas Werner                                    */
/* (c) 1992 Maxon Computer GmbH                                   */
/*----------------------------------------------------------------*/

#include <stdio.h>
#include <tos.h>
#include <aes.h>
#include <vdi.h>


#define MAX(a, b)     ((a>b) ? a : b)
#define MIN(a, b)     ((a>b) ? b : a)


extern int handle, work_out[];



/*----------------------------------------------------------------*/
/*                    LASSO-FUNCTION                              */
/*                                                                */
/*     Call: Lasso(Undo, Mode, handle)                            */
/*     Undo:   1, when screen should have been saved              */
/*     Mode:  Linking types of cuttings (0-15)                    */
/*    handle: Graphic-Handle                                      */
/*----------------------------------------------------------------*/
 
void Lasso(int Undo, int Mode)
{
 void     *Buffer, *Undo_Buffer, *Screen;
 int      Xstart, Ystart, Xmax, Ymax, Xmin, Ymin, XMAX, YMAX;
 int      X, X1, X2, Y, Y1, Y2, Width, Height;
 int      pstatus, dummy, w_out[57], xy[10];
 unsigned int Picx, Picy;
 long Picg;
 MFDB Screen_mfdb, Buffer_mfdb, Undo_mfdb;

 
 void Draw(int x1, int y1, int x2, int y2);
 void Box(int x1, int y1, int x2, int y2);


 
 vsl_type(handle, 1);    /* Line going through */
 vsl_width(handle, 1);
 vsl_ends(handle, 0, 0);
 vsl_color(handle, 1);
 vsf_interior(handle, 1);  /* black filling */
 
 Screen = Physbase();
  Picx = work_out[0];
  Picy = work_out[1];
 vq_extnd(handle,1, w_out);
 Picg = ((Picx+1)/8) * (Picy+1) * w_out[4];
 Screen_mfdb.fd_addr = Screen;
 Screen_mfdb.fd_nplanes = w_out[4];
 Screen_mfdb.fd_w = Picx;
 Screen_mfdb.fd_h = Picy;
 Screen_mfdb.fd_wdwidth = (Picx+1)/16;
 Screen_mfdb.fd_stand = 0;
   
 /* Work buffer in screen size */
 
 Buffer = Malloc(Picg);
  if (Buffer == NULL)
  {
   form_alert(1,"[3][ Not enough free memory! ][ Cancel ]");
   vswr_mode(handle, 1);
   return;
  }
 Buffer_mfdb.fd_addr = Buffer;
 Buffer_mfdb.fd_nplanes = Screen_mfdb.fd_nplanes;
 Buffer_mfdb.fd_w = Picx;
 Buffer_mfdb.fd_h = Picy;
 Buffer_mfdb.fd_wdwidth = (Picx+1)/16;
 Buffer_mfdb.fd_stand = 0;
 
 graf_mouse(M_OFF,0);
 Setscreen(Buffer, Screen, -1);
 v_clrwk(handle);
 Setscreen(Screen, Screen, -1);
 graf_mouse(M_ON,0);


  /* Start value of the rectangle boundary (Screen resolution) */
  
  Xmax = 0;
  Ymax = 0;
  Xmin = Picx;
  Ymin = Picy;
  
  XMAX = Picx-2;
  YMAX = Picy-2;
  
  /* Save Original , when wanted */
  
  if (Undo==1)
  {
  xy[0] = 0;
  xy[1] = 0;
  xy[2] = Picx;
  xy[3] = Picy;
  xy[4] = 0;
  xy[5] = 0;
  xy[6] = Picx;
  xy[7] = Picy;

  Undo_Buffer = Malloc(Picg);
   if (Undo_Buffer == NULL)
   {
    form_alert(1,"[3][ Not enough free memory! ][ Cancel ]");
    Mfree(Buffer);
    vswr_mode(handle, 1);
    return;
   }
  Undo_mfdb.fd_addr = Undo_Buffer;
  Undo_mfdb.fd_nplanes = Screen_mfdb.fd_nplanes;
  Undo_mfdb.fd_w = Picx;
  Undo_mfdb.fd_h = Picy;
  Undo_mfdb.fd_wdwidth = (Picx+1)/16;
  Undo_mfdb.fd_stand = 0;
  
  graf_mouse(M_OFF, 0);
  vro_cpyfm(handle, 3, xy, &Screen_mfdb, &Undo_mfdb);
  graf_mouse(M_ON, 0);
  }
  
 /* Wait on Mouse click and determine start co-ordinates */

  while(graf_mkstate(&Xstart, &Ystart, &pstatus, &dummy),!(pstatus & 1));
 
  X1 = Xstart;
  X2 = X1;
  Y1 = Ystart;
  Y2 = Y1;
 /* Select cutting with the Mouse */
  do
  {
   while(graf_mkstate(&X1, &Y1, &pstatus, &dummy),
        (pstatus & 1) && (X1 == X2) && (Y1 == Y2));
  
    /* Lasso not laid down at the border */
    
    X1 = MIN(X1,XMAX);
    X1 = MAX(X1,2);
    Y1 = MIN(Y1,YMAX);
    Y1 = MAX(Y1,2);
    
    /* Determination of the boundary of the rectangle */
    
    Xmax = MAX(X1 ,Xmax);
    Xmin = MIN(X1 ,Xmin);
    Ymax = MAX(Y1 ,Ymax);
    Ymin = MIN(Y1 ,Ymin);
  
    /* Drawing of the Lassos: */
    
    /* 1) hidden */
  graf_mouse(M_OFF,0);  
  Setscreen(Buffer, Screen, -1);
  vswr_mode(handle, 1);
    Draw(X2, Y2, X1, Y1);
  Setscreen(Screen, Screen, -1);
  graf_mouse(M_ON,0);  
  
    /* 2) viewable */
    
    vswr_mode(handle, 3);
    Draw(X2, Y2, X2, Y2);
    Draw(X2, Y2, X1, Y1);
    
    X2 = X1;
    Y2 = Y1;
  } while((pstatus & 1));
 
  /* Write to the border */
  
  
  Draw(X2, Y2, X2, Y2);
  Draw(Xstart, Ystart, Xstart, Ystart);
  Draw(X2, Y2, Xstart, Ystart);
  
  /* Carry out all in the Buffer from now on */

 graf_mouse(M_OFF,0);
   
 Setscreen(Buffer, Screen, -1);
 vswr_mode(handle, 1);
  Draw(X2, Y2, Xstart, Ystart);
  
  /* Draw Mask through filling of the rectangle boundary */
  
  Width = Xmax-Xmin;
  Height = Ymax-Ymin;
  Box(Xmin-2,Ymin-2,Width+6,Height+6);
  v_contourfill(handle, Xmin-1, Ymin-1, 1);
  
  /* Combine Mask with picture NOT AND */
  
 xy[0] = 0;
 xy[1] = 0;
 xy[2] = Picx;
 xy[3] = Picy;
 xy[4] = 0;
 xy[5] = 0;
 xy[6] = Picx;
 xy[7] = Picy;
 
 vro_cpyfm(handle, 2, xy, &Screen_mfdb, &Buffer_mfdb);
    
  /* All on the viewable screen will be carried out from here on  *
  
 Setscreen(Screen, Screen, -1);
 
  /* Restore picture */
  
  if (Undo==1)
  {
  xy[0] = 0;
  xy[1] = 0;
  xy[2] = Picx;
  xy[3] = Picy;
  xy[4] = 0;
  xy[5] = 0;
  xy[6] = Picx;
  xy[7] = Picy;
  vro_cpyfm(handle, 3, xy, &Undo_mfdb, &Screen_mfdb);
  }
  
  /* carry on working: Moving the cuttings */
  
  xy[0] = 0;
  xy[1] = 0;
  xy[2] = Picx;
  xy[3] = Picy;
  vs_clip(handle, 1, xy);
  
 graf_mkstate(&X, &Y, &pstatus, &dummy);
 
 xy[0] = Xmin;
 xy[1] = Ymin;
 xy[2] = Xmin + Width;
 xy[3] = Ymin + Height;
 xy[4] = X;
 xy[5] = Y;
 xy[6] = X + Width;
 xy[7] = Y + Height;
 
 vro_cpyfm(handle, 6, xy, &Buffer_mfdb, &Screen_mfdb);
 
 graf_mouse(M_ON, 0);
  
  do
  {
   while(graf_mkstate(&X1, &Y1, &pstatus, &dummy),
        (!(pstatus&1)) && (!(pstatus&2)) && (X == X1) && (Y == Y1));
  
  xy[0] = Xmin;
  xy[1] = Ymin;
  xy[2] = Xmin + Width;
  xy[3] = Ymin + Height;
  xy[4] = X;
  xy[5] = Y;
  xy[6] = X + Width;
  xy[7] = Y + Height;
  graf_mouse(M_OFF, 0);
  vro_cpyfm(handle, 6, xy, &Buffer_mfdb, &Screen_mfdb);
  
  X = X1;
  Y = Y1;
  
  xy[0] = Xmin;
  xy[1] = Ymin;
  xy[2] = Xmin + Width;
  xy[3] = Ymin + Height;
  xy[4] = X;
  xy[5] = Y;
  xy[6] = X + Width;
  xy[7] = Y + Height;
  vro_cpyfm(handle, 6, xy, &Buffer_mfdb, &Screen_mfdb);
  graf_mouse(M_ON, 0);
 } while((!(pstatus&1)) && (!(pstatus&2)));
 
 graf_mouse(M_OFF, 0);

 xy[0] = Xmin;
 xy[1] = Ymin;
 xy[2] = Xmin + Width;
 xy[3] = Ymin + Height;
 xy[4] = X;
 xy[5] = Y;
 xy[6] = X + Width;
 xy[7] = Y + Height;
  if (pstatus&2)       /* Copy cuttings in according to Mode */
  vro_cpyfm(handle, Modus, xy, &Buffer_mfdb, &Screen_mfdb);
 else
  vro_cpyfm(handle, 6, xy, &Buffer_mfdb, &Screen_mfdb);

 graf_mouse(M_ON, 0);
  xy[0] = 0;
  xy[1] = 0;
  xy[2] = Picx;
  xy[3] = Picy;
  vs_clip(handle, 0, xy);
   
  /* Release memory */
   
  Mfree(Buffer);
  if (Undo==1)
  Mfree(Undo_Buffer);
  
 Setscreen(Screen, Screen, -1);
 vswr_mode(handle, 1);
 vst_color(handle, 1);
}


/*----------------------------------------------------------------*/
/*            Draw Line                                           */
/*----------------------------------------------------------------*/

void Draw(int x1, int y1, int x2, int y2)
{
 int  xy[4];
 
 xy[0] = x1;
 xy[1] = y1;
 xy[2] = x2;
 xy[3] = y2;
 
 graf_mouse(M_OFF, 0);
 v_pline(handle, 2, xy);
 graf_mouse(M_ON, 0);
}

void Box(int x1, int y1, int x2, int y2)
{
 int  xy[10];
 
 xy[0] = x1;
 xy[1] = y1;
 xy[2] = x2;
 xy[3] = y1;
 xy[4] = x2;
 xy[5] = y2;
 xy[6] = x1;
 xy[7] = y2;
 xy[8] = x1;
 xy[9] = y1;
 
 v_pline(handle, 5, xy);
}
