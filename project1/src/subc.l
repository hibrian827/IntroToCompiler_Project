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
%}

/* Definitions Section */
/* This section contains simple name definitions and declarations of start conditions. */

letter  [A-Za-z_]
%start  AA BB

%%
  /* Rules Section */
  /* This section contains series of rules for recognizing tokens. */
  /* All comments in this section must be indented. */

{letter}  { }

%%

/* User Code Section */
/* The user code section is simply copied to lex.yy.c verbatim. */

int main(int argc, char** argv) {
  // Define reserved keywords
  char *keyword[] = { "int", NULL };
  int tokentype[] = { 0, 0 };  // placeholder; later something like { TYPE, 0 }

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
