#include <stdio.h>

extern int yyparse(void);
extern FILE *yyin;
FILE *codeout;

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Uso: %s entrada.irriga saida.mwasm\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Erro ao abrir arquivo de entrada");
        return 1;
    }

    codeout = fopen(argv[2], "w");
    if (!codeout) {
        perror("Erro ao abrir arquivo de saída");
        fclose(yyin);
        return 1;
    }

    int r = yyparse();

    fclose(yyin);
    fclose(codeout);

    if (r == 0) {
        puts("Programa valido. Codigo gerado.");
        return 0;
    }

    return 1;
}
