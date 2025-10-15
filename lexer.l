%option noyywrap
%option yylineno
%{
#include "parser.h"
#include <string.h>
#include <stdlib.h>
%}

ws     [ \t\r\n]+
id     [A-Za-z][A-Za-z0-9_]*
num    [0-9]+

%%
{ws}                    ;
"if"|"IF"               { return IF; }
"else"|"ELSE"           { return ELSE; }
"while"|"WHILE"         { return WHILE; }
"and"|"AND"             { return AND; }
"or"|"OR"               { return OR; }

"=="                    { return EQ; }
"!="                    { return NE; }
">="                    { return GE; }
"<="                    { return LE; }
">"                     { return GT; }
"<"                     { return LT; }
"="                     { return ASSIGN; }
"->"                    { return ARROW; }

"valvula_on"|"VALVULA_ON"   { return VALV_ON; }
"valvula_off"|"VALVULA_OFF" { return VALV_OFF; }
"bomba_on"|"BOMBA_ON"       { return BOMBA_ON; }
"bomba_off"|"BOMBA_OFF"     { return BOMBA_OFF; }
"delay"|"DELAY"             { return DELAY; }
"ler"|"LER"                 { return LER; }

"umidade"|"UMIDADE"         { return UMIDADE; }
"chuva"|"CHUVA"             { return CHUVA; }
"cisterna"|"CISTERNA"       { return CISTERNA; }
"relogio"|"RELOGIO"         { return RELOGIO; }
"sol"|"SOL"                 { return SOL; }
"vazao"|"VAZAO"             { return VAZAO; }

"+"                     { return '+'; }
"-"                     { return '-'; }
""                     { return ''; }
"/"                     { return '/'; }
"("                     { return '('; }
")"                     { return ')'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
";"                     { return ';'; }

{num}                   { yylval.ival = atoi(yytext); return NUMBER; }
{id}                    { yylval.sval = strdup(yytext); return IDENT; }

.                       { return yytext[0]; }
%%