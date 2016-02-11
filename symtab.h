/* $Id: symtab.h,v 1.2 2013/08/02 20:53:06 bks Exp $ */
/* interface for a simple symbol table */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct tokenInfo
{
  char *name;
  double  value;
  int lineNumber;
};
typedef struct tokenInfo tokenInfo;

/*** We create our own symbol table and functions for it here. ***/
struct varRec
{
  char*  name; /* the name of the variable */
  double value; /* the value the variable has - always a double */
  struct varRec *next; /* a link to the next part of the symbol table */
};

typedef struct varRec varRec;

/* The variable table: a chain of 'struct varRec'. */
extern varRec* varTable;
extern varRec* nextRec;

extern varRec* getVar( char *varName ) ;

extern varRec* putVar( char *varName, float varValue )  ;

extern void clearVar( void ) ;

