/*--------------------------------------------------------------------*/
/*            Fastzoom-Routine                                        */
/*                                                                    */
/* vx,vy  - x/y-Enlargement                                           */
/* x,y    - x/y-Co-ordinate of the left upper corner of the Originals */
/* br     - Width in Pixels                                           */
/* ho     - Height in Pixels                                          */
/* xo,yo  - x/y-Co-ordinate of the left upper corner of enlargement   */
/* mode   - Write mode                                                */
/* handle - Graphic-Handle                                            */
/* screen - Address of the MFDB-Structure of the screens              */
/*--------------------------------------------------------------------*/

void great(int vx,int vy,int x,int y,int br,int ho,int xo,int yo,
     int mode,int handle, MFDB *screen);
