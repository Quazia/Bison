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
%type <ti> sum
%type <ti> product
%type <ti> term
%type <ti> assign
%type <ti> first


%%

program: program statement
       | /* epsilon */
       ;

statement: first NEWLINE 
                             { printf("%g\n", $1.value);
                               lineNumber++;
                             }
           | assign            {  }
         ;

assign:   VARIABLE ASSIGNMENT assign 
                             { $$.value = $3.value;
                               putVar($1.name, $3.value); 
                             }
          | VARIABLE ASSIGNMENT first NEWLINE
                             { $$.value = $3.value;
                               putVar($1.name, $3.value);
                               lineNumber++;
                             }
         ;         


first: expr         { $$.value =  $1.value; }
      | MINUS expr  { $$.value =  0 - $2.value; }
      ;


expr: sum         { $$.value =  $1.value; }
      ;

sum: sum PLUS product      { $$.value = $1.value + $3.value; }
     | sum MINUS product   { $$.value = $1.value - $3.value; }
     | product          { $$.value =  $1.value; }
     ;

product: product MULTIPLY term     { $$.value = $1.value * $3.value; }
         | product DIVIDE term     { $$.value = $1.value / $3.value; }
         | term                { $$.value =  $1.value; }
         ;

term: INTEGER                { $$ = $1; }
      | LEFTPAREN expr RIGHTPAREN { $$.value =  $2.value; }
      | VARIABLE             { if (getVar($1.name)!= 0) {
                                   varRec *tmp = getVar($1.name);
                                   $$.value = tmp->value; 
                               }
                             }
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

