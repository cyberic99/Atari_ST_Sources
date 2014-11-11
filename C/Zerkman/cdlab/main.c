/*
 * MAIN.C - Squelette du programme principal sous GEM
 *
 * Copyright 2004 Francois Galea
 *
 * This file is part of CDLab.
 *
 * CDLab is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * CDLab is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Foobar; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <windom.h>
#include <av.h>
#include <tos.h>

#include "rsc/cdlab.h"
#include "device.h"
#include "prefs.h"
#include "misc.h"
#include "toc_win.h"
#include "copy_win.h"
#include "dev_win.h"
#include "erasewin.h"
#include "tao_win.h"
#include "main.h"

/* #define SPREAD_VERSION       /* A absolument d�finir pour une version diffusable */

/* void audio_test( struct device_info * dev ); */
/* void tao_test( struct device_info * info ); */

char version_string[] = "CDLab v0.90�";
char rsc_name[] = "rsc\\cdlab.rsc";

struct bubble_str { int obj; char * msg; };
struct bubble_str pref_bubble[] =
{ 
  { OB_INFO_NONE, "IB_NOHELP" },
  { OB_INFO_RBUT, "IB_RBHELP" },
  { OB_INFO_TEMP, "IB_TMHELP" },
  { OB_VALUE_TEMP, "IB_TMHVAL" },
  { OB_LOG, "IB_LOG" },
  { OB_LOG_TEXT, "IB_LOGNAM" },
  { OB_LOGFILE, "IB_LOGNAM" },
  { OB_FLUSHLOG, "IB_LOGFLU" },
  { OB_EJECTDST, "IB_EJECTDST" },
  { OB_TIMEOUTS, "IB_TIMEOUT" },
  { OB_TIMEOUT, "IB_TIMEOUT" },
  { OB_PREEMP, "IB_PREEMP" },
  { OB_INTERR, "IB_INTERR" },
  { OB_IGNERR, "IB_IGNERR" },
  { OB_RELECVALS, "IB_RELECVAL" },
  { OB_RELECVAL, "IB_RELECVAL" },
  { OB_EJECTSRC, "IB_EJECTSRC" },
  {0}
};
struct bubble_str copy_bubble[] =
{
  { CB_SRCTXT, "IB_SOURCE" },
  { CB_SOURCE, "IB_SOURCE" },
  { CB_DSTTXT, "IB_DEST" },
  { CB_DEST, "IB_DEST" },
  { CB_WSTXT, "IB_SPEED" },
  { CB_SPEED, "IB_SPEED" },
  { CB_SPDCYC, "IB_SPEED" },
  { CB_SIMUL, "IB_SIMUL" },
  { CB_WR, "IB_WR" },
  { CB_USEHD, "IB_USEHD" },
  { CB_INTTEXT, "IB_INTFILE" },
  { CB_INTFILE, "IB_INTFILE" },
  { CB_INTDEL, "IB_INTDEL" },
  { 0 }
};
struct bubble_str erase_bubble[] =
{
  { EB_ERASE, "IB_ERASE" },
  { EB_COMP, "IB_COMP" },
  { EB_MINI, "IB_MINI" },
  { 0 }
};
struct bubble_str dev_bubble[] =
{
  { DB_RDUNIT, "IB_RDUNIT" },
  { DB_RDUCYC, "IB_RDUNIT" },
  { DB_AUDIOSTR, "IB_AUDIOSTR" },
  { DB_RDCDRW, "IB_RDCDRW" },
  { DB_WRTYPE, "IB_WRTYPE" },
  { DB_WRUNIT, "IB_WRUNIT" },
  { DB_WRUCYC, "IB_WRUNIT" },
  { DB_WRTAO, "IB_WRTAO" },
  { DB_WRDAO, "IB_WDDAO" },
  { DB_WRCDRW, "IB_WRCDRW" },
  { 0 }
};
struct bubble_str tao_bubble[] =
{
  { TB_SRC_TEXT, "IB_TAOSRC" },
  { TB_SRC_FILE, "IB_TAOSRC" },
  { TB_DEST_TEXT, "IB_TAODST" },
  { TB_DEST, "IB_TAODST" },
  { TB_DSTCYC, "IB_TAODST" },
  { TB_WSTXT, "IB_SPEED" },
  { TB_SPEED, "IB_SPEED" },
  { TB_SPDCYC, "IB_SPEED" },
  { TB_SIMUL, "IB_SIMUL" },
  { TB_WR, "IB_WR" },
  { 0 }
};

void protect_decrypt( char * key, char * name );

char device_popup_buf[ MAX_DEVICES + 1 ][ 80 ];
struct device_info * first_dev;

int reg_ok = 0;

OBJECT *info_tree, *info2_tree, *reg_tree;

char path[256];

void reduce_name( char * dest, char * source, int max_len )
{
  if( (int)strlen( source ) <= max_len )
    strcpy( dest, source );
  else
  {
    while( *source != '\\' )
    {
      *dest++ = *source++;
      max_len --;
    }
    *dest = 0;
    strcat( dest, "\\..." );
    max_len -= 4;
    source = source + strlen( source ) - max_len;
    source = strchr( source, '\\' );
    if( *source != 0 )
    {
      strcat( dest, source );
    }
  }
}

void gen_speed_popup( struct popup_str * popup, int max_speed )
{
  static char speed_txt[ MAX_SPEEDS * 8 ];
  static unsigned int speed_val[ MAX_SPEEDS ];
  char * text;
  int i, speed;
  text = speed_txt;
  speed = 1;
  for( i=0; speed<=max_speed && (reg_ok || !i) ; i++ )
  {
    sprintf( text, "%3dx  ", speed );
    speed_val[i] = speed;
    popup->item[i].text = text;
    popup->item[i].info = &(speed_val[i]);
    text = text + strlen( text ) + 1;
    speed = (i+1)*2;
  }
  popup->item_count = i;
}

/* S�lection de fichier
 * pathname : nom du fichier par d�faut, et nouveau nom si OK
 * ext : extension par d�faut (genre "*.INF")
 * title : titre du s�lecteur de fichier
 */
int fileselect( char * pathname, char * ext, const char * title )
{
  char fspath[256];
  char name[80];
  char * pnt;
  int ret;

  strcpy( fspath, pathname );
  if( strlen( pathname ) == 0 )
    name[0] = 0;
  else
  {
    pnt = strrchr( fspath, '\\' ) + 1;
    strcpy( name, pnt );
    *pnt = 0;
  }

  ret = FselInput( fspath, name, ext, get_string( title ), NULL, NULL );
  if( ret )
  {
    strcpy( pathname, fspath );
    strcat( pathname, name );
  }
  return ret;
}

void gen_dev_popup_buf( void )
{
  struct device_info * info;
  int i;
  i = 1;
  sprintf( device_popup_buf[ 0 ], "%-40s", get_string( "TXT_DAOFILE" ) );
  info = first_dev;
  while( info )
  {
    sprintf( device_popup_buf[ i ], "%-40s", info->desc );
    i++;
    info = info->next; 
  }
}

/* G�n�ration d'un popup de devices, en fonction d'un masque
 * de champs obligatoires */
void gen_dev_popup( struct popup_str * popup, unsigned short mask, int file )
{
  struct device_info * info;
  int i, buf_count;
  info = first_dev;
  if( file )
  {
    popup->item[0].text = device_popup_buf[0];
    popup->item[0].info = NULL;
    i = 1;
  }
  else
    i = 0;
  buf_count = 1;
  while( info )
  {
    if( (info->sets->flags & mask) == mask )
    {
      popup->item[i].text = device_popup_buf[buf_count];
      popup->item[i].info = (void*)info;
      i++;
    }
    buf_count ++;
    info = info->next;
  }
  popup->item_count = i;
}

int popup_mgr( WINDOW * win, struct popup_str * popup, int obj )
{
  char * entries[MAX_DEVICES + 1];
  OBJECT * form;
  int i, x, y, mode, ret;
  form = TOOL( win );
  if( !form )
  {
    form = FORM( win );
    mode = OC_FORM;
  }
  else
    mode = OC_TOOLBAR;
  ret = -1;
  if( popup->object == obj )
  {
    objc_offset( form, obj, &x, &y );
    for( i=0; i<popup->item_count; i++ )
      entries[i] = popup->item[i].text;
    ret = MenuPopUp( entries, x, y,
              popup->item_count, -1, popup->selected+1, P_LIST|P_WNDW );
    if(ret>popup->item_count) ret = -1;
    else if(ret>0) ret--;
  }
  else if( form[popup->object].ob_head == obj )
  {
    ret = (popup->selected+1) % popup->item_count;
    obj = popup->object;
  }
  if( ret >= 0 )
  {
    popup->selected = ret;
    ObjcString( form, obj, popup->item[ret].text );
    ObjcDraw( mode, win, obj, MAX_DEPTH );
  }
  return ret;
}

/* Recentrage d'une fen�tre, avec possibilit� de fournir
 * les nouvelles dimensions utiles
 */
void wind_center( WINDOW * win, int w, int h )
{
  int x, y, xx, yy, ww, hh, dummy;
  if( w < 1 )
    WindGet( win, WF_WORKXYWH, &dummy, &dummy, &w, &dummy );
  if( h < 1 )
    WindGet( win, WF_WORKXYWH, &dummy, &dummy, &dummy, &h );
  WindCalc( WC_BORDER, win, 0, 0, w, h, &dummy, &dummy, &ww, &hh );
  if( ww > app.w )
    ww = app.w;
  if( hh > app.h )
    hh = app.h;
  GrectCenter( ww, hh, &xx, &yy );
  WindCalc( WC_WORK, win, xx, yy, ww, hh, &x, &y, &w, &h );
  WindSet( win, WF_WORKXYWH, x, y, w, h );
  win->w_max = ww;
  win->h_max = hh;
  WindSlider( win, VSLIDER );
}

void objc_redraw( OBJECT * tree, int obj )
{
  WINDOW * win;
  OBJECT * form;
  int x, y;
  win = wglb.first;
  while( win )
  {
    if( win->status & WS_FORM )
    {
      form = FORM( win );
      if( form == tree ) break;
    }
    form = TOOL( win );
    if( form == tree ) break;
    win = win->next;
  }
  if( win )
  {
    objc_offset( form, obj, &x, &y );
    ApplWrite( app.id, WM_REDRAW, win->handle, x-3, y-3,
             tree[obj].ob_width+6, tree[obj].ob_height+6 );
  }
}

void objc_enable( OBJECT * tree, int obj, int enable )
{
  if( (!(tree[obj].ob_flags&HIDETREE)) == (!enable) )
  {
    tree[obj].ob_flags ^= HIDETREE;
    objc_redraw( tree, obj );
  }
}

void objc_lock( OBJECT * tree, int obj, int lock )
{
  if( (!(tree[obj].ob_state&DISABLED)) == (lock?1:0) )
  {
    tree[obj].ob_state ^= DISABLED;
    objc_redraw( tree, obj );
  }
}

void objc_select( OBJECT * tree, int obj, int select )
{
  if( (!(tree[obj].ob_state&SELECTED)) == (select?1:0) )
  {
    tree[obj].ob_state ^= SELECTED;
    objc_redraw( tree, obj );
  }
}

void reg_open( void )
{
  memcpy( reg_tree[RB_NAME].ob_spec.tedinfo->te_ptext, preferences.reg.name, 24 );
  memcpy( reg_tree[RB_KEY].ob_spec.tedinfo->te_ptext, preferences.reg.key, 16 );
  open_dialog( reg_tree, get_string( "TXT_REG" ) );
}

void reg_valid( void )
{
  char key[16];
  char * name;
  int i;
  unsigned short value, checksum;
  if( preferences.reg.ok ) return;

  name = reg_tree[RB_NAME].ob_spec.tedinfo->te_ptext;
  memcpy( key, reg_tree[RB_KEY].ob_spec.tedinfo->te_ptext, 16 );
  for( i=(int)strlen(name); i<24; i++ )
    name[i] = 0;
  checksum = 0;
  for( i=0; i<16; i++ )
  {
    checksum <<= 1;
    if( key[i] < 'A' ) key[i] += 'Z' - '0';
    if( key[i] >= 0x51 ) checksum++;
  }
  for( i=0; i<4; i++ )
  {
    value = (((key[i*4]-1)&0x0f)<<12)
             | (((key[i*4+1]-1)&0x0f)<<8)
             | (((key[i*4+2]-1)&0x0f)<<4)
             | ((key[i*4+3]-1)&0x0f);
    checksum += value;
  }
  for( i=0; i<12; i++ )
    checksum += ((unsigned short*)name)[i];
  if( checksum || (!strlen(name)) || (!strlen(key)) )
  {
    alert_msg( "AL_INCKEY", 1 );
    name[0] = 0;
    key[0] = 0;
  }
  else
  {
    alert_msg( "AL_CORKEY", 1 );
    preferences.reg.ok = 1;
    memcpy( preferences.reg.name, name, 24 );
    memcpy( preferences.reg.key, key, 16 );
  }
}

void toolbar_mgr( WINDOW * win )
{
  OBJECT * form;
  int obj;

  form = TOOL( win );
  obj = evnt.buff[4];
  if( form[obj].ob_flags & SELECTABLE )
  {
    if( form[obj].ob_flags & EXIT )
      ObjcChange( OC_TOOLBAR, win, obj, form[obj].ob_state&~SELECTED, 1 );
  }
  ApplWrite( app.id, UE_TOOLBAR, win->handle, obj, 0, 0, 0 );
}

void form_mgr( WINDOW * win )
{
  OBJECT * form;
  int obj;

  form = FORM( win );
  obj = evnt.buff[4];
  if( form[obj].ob_flags & SELECTABLE )
  {
    if( form[obj].ob_flags & EXIT )
      ObjcChange( OC_FORM, win, obj, form[obj].ob_state&~SELECTED, 1 );
  }
  else if( (form[obj].ob_type >> 8) == 24 )  /* Raccourci */
    obj += 1;

  if( form == info_tree )
  {
    switch( obj )
    {
    case IB_INFO:
      open_dialog( info2_tree, get_string( "TXT_INFO" ) );
      break;
    case IB_REG:
      reg_open();
      break;
    case IB_OK:
      ApplWrite( app.id, WM_DESTROY, win->handle );
    }
  }
  else if( form == info2_tree )
  {
    switch( obj )
    {
    case I2B_OK:
      ApplWrite( app.id, WM_DESTROY, win->handle );
    }
  }
  else if( form == reg_tree )
  {
    switch( obj )
    {
    case RB_OK:
      reg_valid();
    default:
      ApplWrite( app.id, WM_DESTROY, win->handle );
    }
  }
  else
    ApplWrite( app.id, UE_CLICKED, win->handle, obj );
}

WINDOW * open_dialog( OBJECT *tree, char *name )
{
  WINDOW * ret;
  ret = FormCreate( tree, DEFAULT_FLAGS, form_mgr, name, NULL, 0, 0 );
  return ret;
}

/*
 * Attention je r�gle le look 
 * que pour le TOS standard, je suppose
 * que c'est ok pour MagiC. C'est pas
 * tr�s rigoureux mal bon en attendant ...
 */

struct objcolor {
		unsigned borderc:4;
		unsigned textc  :4;
		unsigned opaque :1;
		unsigned pattern:3;
		unsigned fillc  :4;
};

void editable3d( OBJECT *tree )
{
  struct objcolor *color;
  int res, ok;

  if( !get_cookie( 'MagX', NULL))
  {
    res = 0;
    ok = 1;
    while( ok )
    {
      if( tree[res].ob_type == G_FTEXT)
      {
        tree[res].ob_state |= SELECTED;
        tree[res].ob_flags |= (1<<9);
        tree[res].ob_flags |= (1<<10);
        color = (struct objcolor*)&tree[res].ob_spec.tedinfo->te_color;
        color -> fillc = 8;
      }
      ok = !(tree[res].ob_flags & LASTOB);
      res ++;
    }
  }
}

void bubble_attach( OBJECT * tree, struct bubble_str * tab )
{
  char * txt;
  int i;
  for( i = 0; tab[i].obj != 0; i++ )
  {
    txt = get_string( tab[i].msg );
    if( txt ) BubbleAttach( tree, tab[i].obj, txt );
  }
}

#define CH_COUNT 6
void context_help( void )
{
  const static int index[CH_COUNT]
    = { INFO_BOX, COPY_BOX, ERASE_BOX, OPT_BOX, DEV_BOX, TRACK_TB };
  const static char * label[CH_COUNT]
    = { "H_INFO_BOX", "H_COPY_BOX", "H_ERASE_BOX", "H_OPT_BOX", "H_DEV_BOX", "H_TOC_WIN" };
  char str[256];

  OBJECT * tree, * current;
  WINDOW * top;
  int i, mode=0;

  top = wglb.appfront;
  if( !top ) return;
  tree = TOOL( top );
  if( !tree )
  {
    mode = 1;
    tree = FORM( top );
  }
  i=0;
  while( i<CH_COUNT )
  {
    rsrc_gaddr( 0, index[i], &current );
    if( current == tree || (mode==0) && !memcmp( tree+1, current+1, sizeof( OBJECT ) ) )
      break;
    i++;
  }
  if( i==CH_COUNT )
    alert_msg( "AL_NOCTHELP", 1 );
  else
  {
    sprintf( str, "*:\\CDLAB.HYP %s", get_string( label[ i ] ) );
    CallStGuide( str );
  }
}

void av_send_key( void )
{
  ApplWrite( app.id, AP_KEYBD, evnt.buff[3], evnt.buff[4] );
}

void av_send_click( void )
{
  ApplWrite( app.id, AP_BUTTON, evnt.buff[3], evnt.buff[4] );
}

int main( void )
{
  OBJECT * tree;
  int ap_id, evnt_ret, event, quit, ret;

  path[0] = Dgetdrv( ) + 'A';
  path[1] = ':';
  Dgetpath( path+2, 0 );

  ap_id = ApplInit();

  if( read_messages_file( "rsc\\messages.dat" ) )
  {
    form_alert( 1, "[1][Messages file not found!][Quit]" );
    ApplExit();
    exit( 1 );
  }

  if( ap_id > 6 ) menu_register( ap_id, "  CDLab" );
  RsrcLoad( rsc_name );
  RsrcXtype( RSRC_XALL, NULL, 0 );

  pref_load();
  first_dev = get_device_list( 0 );

  if( first_dev == (struct device_info*) -1 )
  {
    alert_msg( "AL_NOSCSIDRV", 1 );
    goto init_error;
  }
  gen_dev_popup_buf();

  ret = rsrc_gaddr( 0, INFO_BOX, &info_tree );
  if( !ret )
  {
    form_alert( 1, "[1][Argh][Argh]" );
    return 1;
  }
  rsrc_gaddr( 0, INFO2_BOX, &info2_tree );
  rsrc_gaddr( 0, REG_BOX, &reg_tree );

  editable3d( reg_tree );
  rsrc_gaddr( 0, OPT_BOX, &tree );
  editable3d( tree );
  bubble_attach( tree, pref_bubble );
  rsrc_gaddr( 0, COPY_BOX, &tree );
  bubble_attach( tree, copy_bubble );
  editable3d( tree );
  rsrc_gaddr( 0, ERASE_BOX, &tree );
  bubble_attach( tree, erase_bubble );
  rsrc_gaddr( 0, DEV_BOX, &tree );
  bubble_attach( tree, dev_bubble );
  rsrc_gaddr( 0, TRACK_FR, &tree );
  editable3d( tree );
  rsrc_gaddr( 0, TAO_BOX, &tree );
  bubble_attach( tree, tao_bubble );

  /* Cette ligne semble poser probl�me sous N.AES */
  info_tree[IB_REGTXT].ob_spec.tedinfo->te_ptext = "- Unregistered version -";

#ifdef SPREAD_VERSION
  if( preferences.reg.ok )
  {
    protect_decrypt( preferences.reg.key, preferences.reg.name );
#else
  {
#endif
    info_tree[IB_REG].ob_flags |= HIDETREE;
    memcpy( info_tree[IB_REGTXT].ob_spec.tedinfo->te_ptext, preferences.reg.name, 24 );
    reg_ok = 1;
  }

  EvntAttach( NULL, AV_SENDCLICK, av_send_click );
  EvntAttach( NULL, AV_SENDKEY,   av_send_key );

  rsrc_gaddr( 0, MENU1, &tree );
  MenuBar( tree, 1 );

  quit = 0;
  while( !quit )
  {
    evnt.bclick   = 258;
    evnt.bmask    = 3;
    evnt.bstate   = 0;
    evnt.timer = preferences.bubble_delay * 10;
    event = MU_MESAG;
    if( preferences.pref_flags.bubble == 1 )
      event |= MU_BUTTON;
    else if( preferences.pref_flags.bubble == 2 )
      event |= MU_TIMER;
    evnt_ret = EvntWindom( event );
    if( (evnt_ret & MU_BUTTON && evnt.mbut & 0x02) || (evnt_ret & MU_TIMER) )
      BubbleEvnt();
    if( evnt_ret & MU_MESAG )
    {
      switch( evnt.buff[0] )
      {
      case AP_TERM:
        quit = 1;
        break;
      case MN_SELECTED:
        switch( evnt.buff[4] )
        {
        case M_INFO:
          open_dialog( info_tree, version_string );
          break;
        case M_ERASE:
          erase_open();
          break;
        case M_COPY:
          copy_open();
          break;
        case M_MASTER:
          tao_window_open();
          break;
        case M_TOCREAD:
          toc_open();
          break;
        case M_RESCAN:
          free_device_list( first_dev );
          first_dev = get_device_list( 1 );
          break;
        case M_QUIT:
          quit = 1;
          break;
        case M_DEVICES:
          dev_open();
          break;
        case M_PREFS:
          pref_open();
          break;
        case M_CLOSE:
          ApplWrite( app.id, WM_DESTROY, wglb.front->handle );
          break;
        case M_UNTOP:
          ApplWrite( app.id, WM_BOTTOM, wglb.front->handle );
          break;
        case M_HELP_CDLAB:
          CallStGuide( "*:\\CDLAB.HYP" );
          /* audio_test( first_dev->next->next ); */
          /* tao_test( first_dev ); */
          break;
        case M_HELP_CONTEXT:
          context_help();
          break;
        case M_HELP_INDEX:
          CallStGuide( "*:\\CDLAB.HYP Index" );
          break;
        }
        MenuTnormal( NULL, evnt.buff[3], 1 );
        break;
      }
    }
  }

  /* On ferme proprement toutes les fen�tres */
  while( wglb.first )
  {
     ApplWrite( app.id, WM_DESTROY, wglb.first->handle );
     EvntWindom( MU_MESAG );
  }

  pref_save();
  BubbleFree();
  free_device_list( first_dev );
init_error:
  RsrcXtype( 0, NULL, 0 );
  RsrcFree();
  ApplExit();
  return 0;
}

