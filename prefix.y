%{
#define YYDEBUG 1
#include "symtab.h"
int lineNumber = 1;
%}

/* tokenInfo structs represent variables, integers and expressions. */
%union {
  tokenInfo ti;
}

%token PLUS MINUS TIMES DIVIDE LEFTPAREN RIGHTPAREN NEWLINE
/* terminals need to have a defined type. */
%token <ti> VARIABLE
%token <ti> NUMBER
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
