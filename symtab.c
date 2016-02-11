
#include "symtab.h"

/* implementation of a simple symbol table */

/* The variable table: a chain of 'struct varRec'. */
varRec* varTable = NULL;
varRec* nextRec = NULL;

varRec *getVar( char *varName ) {

  varRec *ptr=NULL, *returnValue=NULL;

  for ( ptr = varTable; ptr != NULL;
        ptr = (varRec *) ptr->next ) {
    if ( !strcmp( ptr->name, varName ) ) {
      returnValue = ptr;
    }
  }
  return returnValue;
}

varRec *putVar( char *varName, float varValue ) {

  varRec *ptr = getVar( varName );
  varRec *returnValue = NULL;

  if ( ptr == NULL ) {
    ptr = (varRec *) malloc( sizeof( varRec ) );
    if ( !varTable) {
      varTable = ptr;
      nextRec = ptr;
    } else nextRec->next = ptr;

    ptr->name = (char *) malloc( strlen( varName ) + 1);
    strcpy( ptr->name, varName );
    ptr->value = varValue;
    ptr->next = (varRec *) 0;
    nextRec = ptr;
    returnValue = ptr;
  } else {
    ptr->value = varValue;
    returnValue = ptr;
  }    
  return returnValue;
};

void clearVar( void ) {
  varRec *ptr, *next;
  for ( ptr = varTable; ptr != (varRec *) 0; ) {
    next = (varRec *) ptr->next;
    free( ptr );
    ptr = next;
  }
};

