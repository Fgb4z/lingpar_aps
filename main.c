#include <stdio.h>
int yyparse(void);
int main(){ int r=yyparse(); if(r==0){ puts("OK"); return 0; } return 1; }