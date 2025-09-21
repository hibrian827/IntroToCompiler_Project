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
%}

/* Definitions Section */
/* This section contains simple name definitions and declarations of start conditions. */

letter  [A-Za-z_]
digit   [0-9]
whitespace  [ \t]

START_COMMENT "/*"
END_COMMENT   "*/"
OP            "("|")"|"["|"]"|"{"|"}"|"."|","|"!"|"*"|"/"|"%"|"+"|"-"|"<"|">"|"&"|";"|"="|"->"|".."|"++"|"--"|"<="|">="|"=="|"!="|"&&"|"||"
WS            ({whitespace}|\n)+
ID            {letter}({digit}|{letter})*
INT_CONST     [1-9]{digit}*|0
FLOAT_CONST   {digit}+\.{digit}*([eE][-+]?{digit}+)?
%start  AA BB

%%
  /* Rules Section */
  /* This section contains series of rules for recognizing tokens. */
  /* All comments in this section must be indented. */

  /* ignore whitespace */
{WS} {}

  /* starting a comment */
<AA>{START_COMMENT} {
  comment_depth++;
  BEGIN BB;
}

  /* starting a nesting comment */
<BB>{START_COMMENT} {
  comment_depth++;
}

  /* ending a comment */
<BB>{END_COMMENT} {
  comment_depth--;
  if(comment_depth == 0) BEGIN AA;
}

  /* ignore rest in comments */
<BB>. {}

  /* if operator detected */
<AA>{OP} {
  printf("OP\t%s\n", yytext);
}

  /* if ID detected */
<AA>{ID} {
  unsigned idx = hash(yytext);
  id *data = search(idx, yytext, yyleng);
  // if it is the first
  if(data == NULL) {
    id *new_data = enter(ID, yytext, yyleng);
    new_data->count++;
    printf("ID\t%s\t1\n", yytext);
  }
  // if it is not the first
  else {
    // if it is an ID
    if(data->tokenType == ID) {
      printf("ID\t%s\t%d\n", data->name, data->count);
    }
    // if it is a keyword
    else {
      printf("KEY\t%s\t%d\n", data->name, data->count);
    }
  }
}

  /* detect .. behind digit */
<AA>{digit}*\./\. {
  // with digit
  if(yyleng > 1) {
    printf("INT\t");
    for(int i = 0; i < yyleng - 1; i++) printf("%c", yytext[i]);
    printf("\n");
  }
  printf("OP\t..\n");
  input();
}

  /* if int constant detected */
<AA>{INT_CONST} {
  printf("INT\t%s\n", yytext);
}
  /* if int constant detected */
<AA>{FLOAT_CONST} {
  printf("F\t%s\n", yytext);
}

%%

/* User Code Section */
/* The user code section is simply copied to lex.yy.c verbatim. */

int main(int argc, char** argv) {
  // Define reserved keywords
  char *keyword[] = { "int", "break", "char", "continue", "else", "float", "for", "if", "return", "struct", "while", "NULL", NULL };
  int tokentype[] = { KEY, KEY, KEY, KEY, KEY, KEY, KEY, KEY, KEY, KEY, KEY, KEY, -1 };  // placeholder; later something like { TYPE, 0 }

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
