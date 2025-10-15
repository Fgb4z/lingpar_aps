#include <stdio.h>
extern int yyparse(void);
extern FILE *yyin;

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) { perror("Erro ao abrir arquivo"); return 1; }
    }
    int r = yyparse();
    if (r == 0) { puts("OK"); return 0; }
    return 1;
}