/*
 *  This is basically KRMALLOC reworked for the config file
 * This will create a memory buffer for config information
 * and provide routines for manipulating it.
 */
#include "lattice.h"
#include <stdlib.h>

#include "globdefs.h"

#ifndef NULL
#define POSTMAGIC	0xd00dc0deL
#define BOUNDSIZE	2


/* CFGmeminit() is basically morecore(), but is only called ONCE

	/* Round nbytes up to a multiple of ALLOCUNIT size */
	cfgp->size = nbytes / ALLOCUNIT;
char * cdecl 
CFGmalloc(unsigned long reqsize) /* was STiKmalloc */
	register HEADER *prevp = cfgp;
	if ( reqsize < MINALLOC )
		reqsize = MINALLOC;

	/* Start at the second block, not the first.  Otherwise, if the first block
		is used, we can't wrap around the linked list */
		p = p->ptr;

		if ( p->size >= nunits )

				/* See if we grabbed the first block */
				if (p == cfgp)

			return (char *) p+sizeof(HEADER);
		prevp = p;
	return NULL;
int cdecl CFGfree(char *ap)
	int		mergebefore=FALSE;
	int		mergeafter=FALSE;

	(char *) bp = ap - sizeof(HEADER);
	
	if ( (unsigned long) bp->ptr != ALLOCMAGIC)
 		disp_info("CFGfree - memory corruption detected");

 		return(E_NORMAL);

	/* First check to see if it's before the first block */
	if ((char *) bp < (char *)cfgp)
	{
		/* Can we merge it with the first block? */
		if ((char *) bp + (ALLOCUNIT * bp->size) == (char *) cfgp)
		{
			bp->size += cfgp->size;
			bp->ptr = cfgp->ptr;
		}
		else
			bp->ptr = cfgp;

		cfgp = bp;

		return(E_NORMAL);
	}
	/* Find where the block should go */
	p = cfgp;
	while ((bp > p->ptr) && (p->ptr != cfgp))
		p = p->ptr;

	if ((char *) bp + (ALLOCUNIT * bp->size) == (char *) p->ptr)
	{
		mergeafter=TRUE;
	}
	
	if ((char *) p + (ALLOCUNIT * p->size) == (char *) bp)
	{
		mergebefore=TRUE;
	}

	if (mergebefore && mergeafter)
	{
		p->size += p->ptr->size + bp->size;
		p->ptr = p->ptr->ptr;
	}
	else if (mergebefore)
	{
		p->size += bp->size;
	}
	else if (mergeafter)
	{
		bp->ptr = p->ptr->ptr;
		bp->size += p->ptr->size;
		p->ptr = bp;
	}
	else /* no merge, put in list */
	{
		bp->ptr = p->ptr;
		p->ptr = bp;
	}
	
	return(E_NORMAL);
}

char * cdecl CFGrealloc(char *ob, unsigned long newsize)

		ob = CFGmalloc(newsize);
		if ( ob != NULL )

		return ob;
		return NULL;
	oldunits = p->size;
	if ( newsize < MINALLOC )
	{
		newsize = MINALLOC;
	}

	nunits = 1L + ( ( (newsize - MINALLOC) % ALLOCUNIT ) != 0L ) + ( ( newsize - MINALLOC ) /ALLOCUNIT );
	if ( (oldunits >= nunits) && ((oldunits - nunits) < 2))
		return (ob);
		if ((newp = CFGmalloc(newsize)) == NULL)
			return NULL;

		CFGmemcpy((uint32 *)newp, (uint32 *)ob, ((oldunits - 1L) * ALLOCUNIT) );
		CFGfree(ob);
	return ob;
		{
			if (bsize > len)
			}