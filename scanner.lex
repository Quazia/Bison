// file: sacnner.y
// date: Sat 2/15/15
//

/* >>OLD VERSION CONTROL<< $Id: scanner.lex,v 1.2 2013/08/02 20:53:06 bks Exp $ */

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

/**////////////////////////////////////////////////////////////////////////
// @file prefix.y
// @author RIT CS dept(BKS) with modifications by all3187 : Arthur Lunn
// @date 2.15.16
// @ Basic lexical analyzer for processing arithmatic.
/////////////////////////////////////////////////////////////////////////*/    

%%

[a-zA-Z][a-zA-Z0-9]*   { yylval.ti.value = 0;
          yylval.ti.name =  (char *) strdup(yytext);
          printf("VARIABLE: %s\n", yylval.ti.name);
        } // Handles all alphanumeric strings (does not handle _)

[0-9]+  { yylval.ti.value = atoi(yytext);
          yylval.ti.name = NULL;
          printf("INTEGER: %g\n", yylval.ti.value);
        } // Handles Ints

[0-9]+[.][0-9]+  { yylval.ti.value = atof(yytext);
          yylval.ti.name = NULL;
          printf("DOUBLE: %g\n", yylval.ti.value);
        } // Handles Doubles

=      printf("ASSIGNMENT\n");
\+     printf("PLUS\n");
\*     printf("MULTIPLY\n");
\n     printf("NEWLINE\n");
[ \n\t]     ;   // Should handle all whitespace 
.      printf("Invalid character: \"%s\"\n", yytext);// Should return the invalid character along with a message

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

