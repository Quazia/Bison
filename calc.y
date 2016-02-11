%{
#define YYDEBUG 1
#include "symtab.h"

int lineNumber = 1;

%}
%union {
  tokenInfo ti;
}

%token ASSIGNMENT PLUS MINUS MULTIPLY DIVIDE NEWLINE LEFTPAREN RIGHTPAREN
%token <ti> VARIABLE 
%token <ti> INTEGER 
%type <ti> expr

%%

program: program statement
       | /* epsilon */
       ;

statement: expr NEWLINE 
                             { printf("%g\n", $1.value);
                               lineNumber++;
                             }
         | VARIABLE ASSIGNMENT expr NEWLINE
                             { putVar($1.name, $3.value);
                               lineNumber++;
                             }
         ;

expr: INTEGER                { $$ = $1; }
      | VARIABLE             { if (getVar($1.name)!= 0) {
                                   varRec *tmp = getVar($1.name);
                                   $$.value = tmp->value; 
                               }
                             }
      | expr PLUS expr      { $$.value = $1.value + $3.value; }
      | expr MULTIPLY expr  { $$.value = $1.value * $3.value; }
      ;

%%
#include "calc.yy.c"

int yyerror( char *s ) {

  fprintf(stderr, "Error: %s at line number %d\n", s, lineNumber);
  return 0;
}

int main( int argc, char* argv[] ) {

#if YYDEBUG 
  yydebug = 0;
#endif /* YYDEBUG */
  int result = yyparse();
  clearVar();
  return result;
}

