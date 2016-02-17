// file: prefix.y
// date: Sat 2/15/15
//

%{
#define YYDEBUG 1
#include "symtab.h"
int lineNumber = 1;
%}


/**////////////////////////////////////////////////////////////////////////
// @file prefix.y
// @author RIT CS dept with modifications by all3187 : Arthur Lunn
// @date 2.15.16
// @ Basic compiler for processing lisp-like prefix arithmatic.
/////////////////////////////////////////////////////////////////////////*/    


/* tokenInfo structs represent variables, integers and expressions. */
%union {
  tokenInfo ti;
}

%token PLUS MINUS TIMES DIVIDE LEFTPAREN RIGHTPAREN NEWLINE
/* terminals need to have a defined type. */
%token <ti> VARIABLE
%token <ti> NUMBER
%type <ti> add
%type <ti> mlt
%type <ti> dvd
%type <ti> sbk
%type <ti> dvd2
%type <ti> sbk2
%type <ti> op


/* non-terminals need a defined type if they pass values through the grammar. */
%type <ti> expr

%%

program: program statement
         | /* EMPTY */
       ;

statement: expr NEWLINE 
	     { printf("%g\n", $1.value); lineNumber++; }
         ;

expr: NUMBER            { $$ = $1; }
      | LEFTPAREN op { $$.value =  $2.value; }
    ;

op: PLUS add        { $$.value =  $2.value; }
    | sbk           { $$.value =  $1.value; }
    | dvd           { $$.value =  $1.value; }
    | TIMES mlt     { $$.value =  $2.value; }    
    ;

add:  RIGHTPAREN   { $$.value =  0; }
      | expr add        { $$.value =  $1.value + $2.value; }
    ;

sbk:  MINUS expr RIGHTPAREN   { $$.value =  0 - $2.value; }
      | MINUS expr sbk2       { $$.value =  $2.value - $3.value; }
    ;

sbk2: expr sbk2              { $$.value =  $1.value + $2.value; }
      | expr RIGHTPAREN      { $$.value =  $1.value; }
    ;

dvd:  DIVIDE expr RIGHTPAREN   { $$.value =  1 / $2.value; }
      | DIVIDE expr dvd2       { $$.value =  $2.value / $3.value; }
    ;

dvd2: expr dvd2               { $$.value =  $1.value * $2.value; }
      | expr RIGHTPAREN       { $$.value =  $1.value; }
    ;

mlt:  RIGHTPAREN   { $$.value =  1; }
      | expr add        { $$.value =  $1.value * $2.value; }
    ;

%%
#include "prefix.yy.c"
int yyerror(char *s ) {
  fprintf(stderr, "Error: %s at line number %d\n", s, lineNumber);
  return 0;
}

int main() {

#if YYDEBUG 
  /* code can access the yydebug variable only if the YYDEBUG is defined. */
  yydebug = 0;
#endif /* YYDEBUG */
  yyparse();
  clearVar();
  return 0;
}
