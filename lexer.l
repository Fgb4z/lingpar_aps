%{
#include "parser.h"
#include <stdlib.h>
#include <string.h>

extern int yylineno;

static char *my_strdup(const char *s) {
    size_t n = strlen(s) + 1;
    char *p = malloc(n);
    if (p) memcpy(p, s, n);
    return p;
}
%}

digit   [0-9]
id      [a-zA-Z_][a-zA-Z0-9_]*

%%

"if"|"IF"                { return IF; }
"else"|"ELSE"            { return ELSE; }
"while"|"WHILE"          { return WHILE; }

"&&"                     { return AND; }
"||"                     { return OR; }

"=="                     { return EQ; }
"!="                     { return NE; }
">="                     { return GE; }
"<="                     { return LE; }
">"                      { return GT; }
"<"                      { return LT; }

"="                      { return ASSIGN; }
"->"                     { return ARROW; }

"valvula_on"|"VALVULA_ON"    { return VALV_ON; }
"valvula_off"|"VALVULA_OFF"  { return VALV_OFF; }
"bomba_on"|"BOMBA_ON"        { return BOMBA_ON; }
"bomba_off"|"BOMBA_OFF"      { return BOMBA_OFF; }
"delay"|"DELAY"              { return DELAY; }
"ler"|"LER"                  { return LER; }

"umidade"|"UMIDADE"          { return UMIDADE; }
"chuva"|"CHUVA"              { return CHUVA; }
"cisterna"|"CISTERNA"        { return CISTERNA; }
"relogio"|"RELOGIO"          { return RELOGIO; }
"sol"|"SOL"                  { return SOL; }
"vazao"|"VAZAO"              { return VAZAO; }

{digit}+                 { yylval.ival = atoi(yytext); return NUMBER; }
{id}                     { yylval.sval = my_strdup(yytext); return IDENT; }

[ \t\r]+                 { }
\n                       { yylineno++; }

"//".*                   { }

[\200-\377]+             { }

.                        { return yytext[0]; }

%%

int yywrap(void) { return 1; }
