/* $Id: scanner.lex,v 1.2 2013/08/02 20:53:06 bks Exp $ */

%{

/**** scanner: the beginnings of a calculator. ****/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct tokenInfo {
  char*   name;
  double  value;
};
typedef struct tokenInfo tokenInfo;

struct tokenInfo2 {
  tokenInfo ti;
};  
struct tokenInfo2 yylval;

%}

%%

[a-z]   { yylval.ti.value = 0;
          yylval.ti.name =  (char *) strdup(yytext);
          printf("VARIABLE: %s\n", yylval.ti.name);
        }

[0-9]+  { yylval.ti.value = atoi(yytext);
          yylval.ti.name = NULL;
          printf("INTEGER: %g\n", yylval.ti.value);
        }

=      printf("ASSIGNMENT\n");
\+     printf("PLUS\n");
\*     printf("MULTIPLY\n");
\n     printf("NEWLINE\n");
[ ]    ;
.      printf("Invalid character\n");

%%

/*
 * @return 1 means keep scanning forever
 */
int yywrap() {
 return 1;
}

/*
 * main for lexical scanner 
 * @param argc 1 if no filename given; 2 if filename
 * @param argv contains program name and optional filename
 */
main( int argc, char *argv[] ) {

  ++argv, --argc;  /* skip over program name */
  /* read source text from file if provided */
  if ( argc > 0 )
    yyin = fopen( argv[0], "r" );
  else
    yyin = stdin;
  
  /* call the flex scanner */
  return yylex();
}

