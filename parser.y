%{ 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char*);
int yylex(void);
extern int yylineno;

extern FILE *codeout;

int new_label_id = 0;

char *new_label() {
    char *buf = malloc(32);
    sprintf(buf, "L%d", new_label_id++);
    return buf;
}
%}

%define parse.error verbose
%locations
%start program

%union { int ival; char* sval; }

%token IF ELSE WHILE AND OR
%token EQ NE GT LT GE LE
%token ASSIGN ARROW
%token VALV_ON VALV_OFF BOMBA_ON BOMBA_OFF DELAY LER
%token UMIDADE CHUVA CISTERNA RELOGIO SOL VAZAO
%token <sval> IDENT
%token <ival> NUMBER

%left OR
%left AND
%left EQ NE GT LT GE LE
%left '+' '-'
%left '*' '/'

%%

program
    : stmts
      { fprintf(codeout, "HALT\n"); }
    ;

stmts
    : /* vazio */
    | stmts stmt
    ;

stmt
    : assign ';'
    | if_stmt
    | while_stmt
    | command ';'
    ;

assign
    : IDENT ASSIGN expr
      {
          if (strcmp($1, "x") == 0) {
          }
      }
    ;

if_stmt
    : IF '(' bexpr ')' block
      {
          char *l_end = new_label();
          fprintf(codeout, "DECJZ TIME %s\n", l_end);
          fprintf(codeout, "%s:\n", l_end);
          free(l_end);
      }
    | IF '(' bexpr ')' block ELSE block
      {
          char *l_else = new_label();
          char *l_end = new_label();
          fprintf(codeout, "DECJZ TIME %s\n", l_else);
          fprintf(codeout, "GOTO %s\n", l_end);
          fprintf(codeout, "%s:\n", l_else);
          fprintf(codeout, "%s:\n", l_end);
          free(l_else);
          free(l_end);
      }
    ;

while_stmt
    : WHILE '(' bexpr ')' block
      {
          char *l_begin = new_label();
          char *l_end = new_label();
          fprintf(codeout, "%s:\n", l_begin);
          fprintf(codeout, "DECJZ TIME %s\n", l_end);
          fprintf(codeout, "GOTO %s\n", l_begin);
          fprintf(codeout, "%s:\n", l_end);
          free(l_begin);
          free(l_end);
      }
    ;

block
    : '{' stmts '}'
    ;

command
    : actuator_cmd
    | sensor_read
    ;

actuator_cmd
    : VALV_ON '(' expr ')'
      {
          fprintf(codeout, "PUSH TIME\n");
          fprintf(codeout, "PRINT\n");
          fprintf(codeout, "POP TIME\n");
      }
    | VALV_OFF '(' expr ')'
      {
          fprintf(codeout, "PUSH TIME\n");
          fprintf(codeout, "PRINT\n");
          fprintf(codeout, "POP TIME\n");
      }
    | BOMBA_ON
      {
          fprintf(codeout, "SET POWER 1\n");
      }
    | BOMBA_OFF
      {
          fprintf(codeout, "SET POWER 0\n");
      }
    | DELAY '(' expr ')'
      {
          char *lend = new_label();
          fprintf(codeout, "%s:\n", lend);
          fprintf(codeout, "DECJZ TIME %s_end\n", lend);
          fprintf(codeout, "GOTO %s\n", lend);
          fprintf(codeout, "%s_end:\n", lend);
          free(lend);
      }
    ;

sensor_read
    : LER '(' CHUVA ')' ARROW IDENT
      {
          if (strcmp($6, "x") == 0) {
              fprintf(codeout, "SET TIME 60\n");
          }
      }
    | LER '(' CISTERNA ')' ARROW IDENT
      {
          if (strcmp($6, "x") == 0) {
              fprintf(codeout, "SET TIME 100\n");
          }
      }
    | LER '(' RELOGIO ')' ARROW IDENT
      {
          if (strcmp($6, "x") == 0) {
              fprintf(codeout, "SET TIME 12\n");
          }
      }
    | LER '(' SOL ')' ARROW IDENT
      {
          if (strcmp($6, "x") == 0) {
              fprintf(codeout, "SET TIME 1\n");
          }
      }
    | LER '(' UMIDADE ',' expr ')' ARROW IDENT
      {
          if (strcmp($8, "x") == 0) {
              fprintf(codeout, "SET TIME 50\n");
          }
      }
    | LER '(' VAZAO ',' expr ')' ARROW IDENT
      {
          if (strcmp($8, "x") == 0) {
              fprintf(codeout, "SET TIME 25\n");
          }
      }
    ;

expr
    : term
    | expr '+' term
      {
          fprintf(codeout, "PUSH TIME\n");
      }
    | expr '-' term
      {
          fprintf(codeout, "PUSH TIME\n");
      }
    | expr '*' term
      {
          fprintf(codeout, "PUSH TIME\n");
      }
    | expr '/' term
      {
          fprintf(codeout, "PUSH TIME\n");
      }
    ;

term
    : NUMBER
      {
          fprintf(codeout, "SET TIME %d\n", $1);
      }
    | IDENT
      {
          if (strcmp($1, "x") == 0) {
          }
      }
    | '(' expr ')'
    ;

bexpr
    : rel
    | bexpr AND rel
    | bexpr OR rel
    ;

rel
    : expr EQ expr
    | expr NE expr
    | expr GT expr
      {
      }
    | expr LT expr
    | expr GE expr
    | expr LE expr
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "erro sintatico na linha %d: %s\n", yylineno, s);
}
