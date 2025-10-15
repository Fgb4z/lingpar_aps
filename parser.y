%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char*);
int yylex(void);
int yylineno;
%}

/%define parse.error verbose/
/%locations/
/%start program/

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

program: stmts ;
stmts: /* vazio */ | stmts stmt ;
stmt: assign ';' | if_stmt | while_stmt | command ';' ;
assign: IDENT ASSIGN expr ;
if_stmt: IF '(' bexpr ')' block
       | IF '(' bexpr ')' block ELSE block ;
while_stmt: WHILE '(' bexpr ')' block ;
block: '{' stmts '}' ;
command: actuator_cmd | sensor_read ;
actuator_cmd: VALV_ON '(' expr ')' 
            | VALV_OFF '(' expr ')'
            | BOMBA_ON
            | BOMBA_OFF
            | DELAY '(' expr ')' ;
sensor_read: LER '(' CHUVA ')' ARROW IDENT
           | LER '(' CISTERNA ')' ARROW IDENT
           | LER '(' RELOGIO ')' ARROW IDENT
           | LER '(' SOL ')' ARROW IDENT
           | LER '(' UMIDADE ',' expr ')' ARROW IDENT
           | LER '(' VAZAO ',' expr ')' ARROW IDENT ;
expr: term
    | expr '+' term
    | expr '-' term
    | expr '*' term
    | expr '/' term ;
term: NUMBER | IDENT | '(' expr ')' ;
bexpr: rel
     | bexpr AND rel
     | bexpr OR rel ;
rel: expr EQ expr | expr NE expr | expr GT expr | expr LT expr | expr GE expr | expr LE expr ;

%%

void yyerror(const char* s){ fprintf(stderr,"erro sintatico na linha %d: %s\n", yylineno, s); }

int main(void) {
    if (yyparse() == 0)
        printf("Programa valido (analise lexica + sintatica OK).\n");
    else
        printf("Erro sintatico encontrado.\n");
    return 0;
}