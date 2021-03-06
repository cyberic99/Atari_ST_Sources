/*--------------------------------------------------------------------*/
/*            Fastzoom-Routine                                        */
/*                                                                    */
/* Original routine in GFA-BASIC: Gerald Schmieder                    */
/* C-Convertion: Thomas Werner                                        */
/* (c) 1992 MAXON Computer GmbH                                       */
/*--------------------------------------------------------------------*/


#include <vdi.h>


/*-----------------------------------------------------------------------*/
/*            Fastzoom-Routine                                           */
/*                                                                       */
/* vx,vy  - x/y-Enlargement                                              */
/* x,y    - x/y-Co-ordinate of the left upper corner of the Original     */
/* br     - Width in Pixels                                              */
/* ho     - Height in Pixels                                             */
/* xo,yo  - x/y-Co-ordinate of the left upper corner of the enlargement  */
/* mode   - Write mode                                                   */
/* handle - Graphic-Handle                                               */
/* schirm - Address of the MFDB-Structure of the screens                 */
/*-----------------------------------------------------------------------*/

void great(int vx,int vy,int x,int y,int br,int ho,int xo,int yo,
     int mode,int handle, MFDB *screen)
{
 int  i, j, xw, yw, xy[8];
 
  /*-----------------------------------------------------*/
  /* The enlargement loops run backwards,as problems     */
  /* may otherwise appear there, if parts of the copy    */
  /* in the Original are too much, like:                 */
  /* Enlarging already enlarged Graphic sections !!!     */
  /*-----------------------------------------------------*/
 
 
  /**** Enlargement of the pattern at the Y-Axis ****/
  
  for (i=(y+ho); i>=y; i--)    /* Loop for reading in of the lines */
  {
   xy[0] = x;
   xy[1] = i;
   xy[2] = x+br;
   xy[3] = i;
   yw = yo+((i-y)*vy);
    for (j=0; j<vy; j++)    /* Loop for setting the line */
    {
    xy[4] = xo;
    xy[5] = yw-j;
    xy[6] = xo+br;
    xy[7] = yw-j;
      vro_cpyfm(handle,mode,xy,screen,screen);
    }
 }
  
  /**** Enlargement of the copy to the X-Axis ****/
  
  for (i=xo+br; i>xo; i--)   /* Loop for reading in of the columns */
  {
   xy[0] = i;
   xy[1] = yo;
   xy[2] = i;
   xy[3] = yo+(ho*vy);
   xw = xo+((i-xo)*vx);
    for (j=0; j<vx; j++)    /* Loop for setting of the columns */
    {
    xy[4] = xw-j;
    xy[5] = yo;
    xy[6] = xw-j;
    xy[7] = yo+(ho*vy);
      vro_cpyfm(handle,mode,xy,screen,screen);
    }
  }
}
