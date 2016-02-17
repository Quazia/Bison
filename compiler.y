// file: compiler.y
// date: Sat 2/15/15
//

%{
#define YYDEBUG 1
/* added YYERROR_VERBOSE for ubuntu porting. 2013 */
#define YYERROR_VERBOSE

#include "compiler.h"

/**////////////////////////////////////////////////////////////////////////
// @file compiler.y
// @author RIT CS dept with modifications by all3187 : Arthur Lunn
// @date 2.15.16
// @ Basic compiler for processing arithmatic with basic program flow control.
/////////////////////////////////////////////////////////////////////////*/    



int lineNumber = 1;

%}
%union {
  tokenInfo ti;
}

%token PLUS MINUS TIMES DIVIDE LEFTPAREN RIGHTPAREN LEFTBRACE RIGHTBRACE
%token IF THEN ELSE FOR SEMI NEWLINE ASGN
%token LT GT LE GE EQ NE
%token <ti> VARIABLE
%token <ti> NUMBER
%type <ti> sum
%type <ti> primary
%type <ti> block
%type <ti> statements
%type <ti> statement
%type <ti> asgnstmt
%type <ti> ifstmt
%type <ti> forstmt
%type <ti> condition

%%

program: block { printf("%s\n", $1.code); }
       ;

block: LEFTBRACE statements RIGHTBRACE { $$.code = $2.code; }
       ;

statements: statement { $$.code = $1.code; }
            | statement SEMI statements { $$.code = cat2($1.code, $3.code); }
            ;

statement: ifstmt { $$.code = $1.code; }
           | forstmt { $$.code = $1.code; }
           | asgnstmt { $$.code = $1.code; }
           | sum { $$.code = $1.code; }
           | /* EMPTY */ { $$.code = strdup(""); }
           ;

asgnstmt : VARIABLE ASGN sum { $$.code = cat4( $3.code,
                                               "   STA ",
                                               $1.code,
                                               "\n"); }
           ;


// Right now it's just storing the raw information
forstmt: FOR asgnstmt condition asgnstmt block {
    $$.code = cat4($2.code,
                   $3.code,
                   $4.code,
                   $5.code
                   );
}


ifstmt: IF condition THEN block ELSE block {
    char *L1 = getlabel();
    char *L2 = getlabel();
    $$.code = cat7($2.code,
                   cat3("   BF  ", L1, "\n"),
                   $4.code,
                   cat3("   B   ", L2, "\n"),
                   cat2(L1, ":\n"),
                   $6.code,
                   cat2(L2, ":\n"));
}

condition: sum LT sum { char * t = gettemp();
                        $$.code = cat8($3.code,
                                       "   STA ", t, "\n",
                                       $1.code,
                                       "   LT  ", t, "\n"); }
           | sum GT sum { char * t = gettemp();
                          $$.code = cat8($3.code,
                                         "   STA ", t, "\n",
                                         $1.code,
                                         "   GT  ", t, "\n"); }
           | sum LE sum { char * t = gettemp();
                          $$.code = cat8($3.code,
                                         "   STA ", t, "\n",
                                         $1.code,
                                         "   LE  ", t, "\n"); }
           | sum GE sum { char * t = gettemp();
                          $$.code = cat8($3.code,
                                         "   STA ", t, "\n",
                                         $1.code,
                                         "   GE  ", t, "\n"); }
           | sum EQ sum { char * t = gettemp();
                          $$.code = cat8($3.code,
                                         "   STA ", t, "\n",
                                         $1.code,
                                         "   EQ  ", t, "\n"); }
           | sum NE sum { char * t = gettemp();
                          $$.code = cat8($3.code,
                                         "   STA ", t, "\n",
                                         $1.code,
                                         "   NE  ", t, "\n"); }
           ;

sum: primary { $$.code = $1.code; }
     | sum PLUS primary { char * t = gettemp();
                          $$.code = cat8($3.code,
                                         "   STA ", t, "\n",
                                         $1.code,
                                         "   ADD ", t, "\n"); }
     | sum TIMES primary { char * t = gettemp();
                           $$.code = cat8($3.code,
                                          "   STA ", t, "\n",
                                          $1.code,
                                          "   ADD ", t, "\n"); }
     ;

primary: NUMBER { $$.code = cat3("   LDI ", $1.code, "\n"); }
         | VARIABLE { $$.code = cat3("   LDA ", $1.code, "\n"); }
         | LEFTPAREN sum RIGHTPAREN { $$.code = $2.code; }
         ;

%%

#include "compiler.yy.c"

int yyerror(char *s ) {
  fprintf(stderr, "Error: %s at line number %d\n", s, lineNumber);
  return 0;
}

int main() {

#if YYDEBUG 
  yydebug = 0;
#endif /* YYDEBUG */
  yyparse();
  clearVar();
  return 0;
}
