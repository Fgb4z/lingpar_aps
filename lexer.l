%option noyywrap
%option yylineno
%{
#include "parser.h"
#include <string.h>
%}


ws [ \t\r\n]+
id [A-Za-z][A-Za-z0-9_]*
num [0-9]+


%%
{ws} ;
"if" return IF;
"else" return ELSE;
"while" return WHILE;
"and" return AND;
"or" return OR;
"==" return EQ;
"!=" return NE;
">=" return GE;
"<=" return LE;
">" return GT;
"<" return LT;
"=" return ASSIGN;
"->" return ARROW;
"valvula_on" return VALV_ON;
"valvula_off" return VALV_OFF;
"bomba_on" return BOMBA_ON;
"bomba_off" return BOMBA_OFF;
"delay" return DELAY;
"ler" return LER;
"umidade" return UMIDADE;
"chuva" return CHUVA;
"cisterna" return CISTERNA;
"relogio" return RELOGIO;
"sol" return SOL;
"vazao" return VAZAO;
"+" return '+';
"-" return '-';
"*" return '*';
"/" return '/';
"(" return '(';
")" return ')';
"{" return '{';
"}" return '}';
";" return ';';
{num} { yylval.ival=atoi(yytext); return NUMBER; }
{id} { yylval.sval=strdup(yytext); return IDENT; }
. { return yytext[0]; }
%%