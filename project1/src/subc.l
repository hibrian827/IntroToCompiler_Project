/*                                                                          */
/* File Name    : subc.l                                                    */
/* Description  : A flex input                                              */
/*                                                                          */
/* Course       : Introduction to Compilers                                 */
/* Dept. of Electrical and Computer Engineering, Seoul National University  */
/*                                                                          */

%{
/* C Code Section */
/* Any code placed inside the brackets will be literally copied into the generated C file. */

#include "subc.h"
static int comment_depth = 0;

#define ID 0
#define KEY 1
#define OP 2
%}

/* Definitions Section */
/* This section contains simple name definitions and declarations of start conditions. */

letter  [A-Za-z_]
digit   [0-9]
whitespace  [ \t]

ID          {letter}({digit}|{letter})*
INT_CONST   [1-9]{digit}*|0
FLOAT_CONST {digit}+\.{digit}*([eE][-+]?{digit}+)?
%start  AA BB

%%
  /* Rules Section */
  /* This section contains series of rules for recognizing tokens. */
  /* All comments in this section must be indented. */

  /* ignore whitespace */
{whitespace}+ {}

  /* if ID detected */
{ID} {
  unsigned idx = hash(yytext);
  id *data = search(idx, yytext, yyleng);
  // if it is the first
  if(data == NULL) {
    enter(ID, yytext, yyleng);
    printf("ID\t%s\t1\n", yytext);
  }
  // if it is not the first
  else {

  }
}
  /* if int constant detected */
{INT_CONST} {
  printf("INT\t%s\n", yytext);
}
  /* if int constant detected */
{FLOAT_CONST} {
  printf("FLOAT\t%s\n", yytext);
}

%%

/* User Code Section */
/* The user code section is simply copied to lex.yy.c verbatim. */

int main(int argc, char** argv) {
  // Define reserved keywords
  char *keyword[] = { "int", NULL };
  int tokentype[] = { KEY, 0 };  // placeholder; later something like { TYPE, 0 }

  // Initialize the hash table
  for(int i=0; keyword[i] != NULL; i++) {
    enter(tokentype[i], keyword[i], strlen(keyword[i]));
  }

  // I/O stream settings
  if (argc >= 2) {
    yyin = fopen(argv[1], "r");
  } else {
    yyin = stdin;
  }

  if(!yyin) {
    printf("Can't open input stream!\n");
    exit(1);
  }

  // Begin scanning with the initial mode 'AA'.
  BEGIN AA;
  yylex ();
  fclose(yyin);

  return 0;
}
