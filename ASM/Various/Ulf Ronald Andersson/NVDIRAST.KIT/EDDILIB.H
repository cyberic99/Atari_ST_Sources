typedef struct
{
	LONG	size;					/* L�nge der Struktur, mu� vor vqt_xfntinfo() gesetzt werden */
	WORD	format;				/* Fontformat, z.B. 4 f�r TrueType */
	WORD	id;					/* Font-ID, z.B. 6059 */
	WORD	index;				/* Index */
	BYTE	font_name[50];		/* vollst�ndiger Fontname, z.B. "Century 725 Italic BT" */
	BYTE	family_name[50];	/* Name der Fontfamilie, z.B. "Century725 BT" */
	BYTE	style_name[50];	/* Name des Fontstils, z.B. "Italic" */
	BYTE	file_name1[200];	/* Name der 1. Fontdatei, z.B. "C:\FONTS\TT1059M_.TTF" */
	BYTE	file_name2[200];	/* Name der optionalen 2. Fontdatei */
	BYTE	file_name3[200];	/* Name der optionalen 3. Fontdatei */
	WORD	pt_cnt;				/* Anzahl der Punkth�hen f�r vst_point(), z.B. 10 */
	WORD	pt_sizes[64];		/* verf�gbare Punkth�hen, z.B. { 8, 9, 10, 11, 12, 14, 18, 24, 36, 48 } */
} XFNT_INFO;

/* Funktionsprototypen */
void  v_opnbm( WORD *work_in, MFDB *bitmap, WORD *handle, WORD *work_out );
void  v_clsbm( WORD handle );
void  vq_scrninfo( WORD handle, WORD *work_out );
void	_v_bez( WORD handle, WORD count, WORD *xyarr,
				 BYTE *bezarr, WORD *extent, WORD *totpts,
				 WORD *totmoves );
void	_v_bez_fill( WORD handle, WORD count, WORD *xyarr,
				 BYTE *bezarr, WORD *extent, WORD *totpts,
				 WORD *totmoves );

WORD	vqt_xfntinfo( WORD handle, WORD flags, WORD id, WORD index, XFNT_INFO *info );
