FL_LIB := $(shell test -f /opt/homebrew/opt/flex/lib/libfl.a && echo /opt/homebrew/opt/flex/lib/libfl.a || echo -lfl)

.PHONY: all run clean

all: irriga_comp

irriga_comp: parser.c lexer.c main.c
	@gcc -O2 -std=c11 -Wall -Wextra -pedantic -o irriga_comp main.c lexer.c parser.c $(FL_LIB)
	@echo "✅ Compilação concluída!"

parser.c parser.h: parser.y
	@bison -d -o parser.c parser.y

lexer.c: lexer.l parser.h
	@flex -o lexer.c lexer.l

run: all
	@if [ -f exemplo.irriga ]; then \
	  echo "▶  Compilando exemplo.irriga..."; \
	  ./irriga_comp exemplo.irriga exemplo.mwasm; \
	  echo "✅ Código gerado em exemplo.mwasm"; \
	else \
	  echo "⚠  Arquivo exemplo.irriga não encontrado. Crie um e rode 'make run' novamente."; \
	fi

clean:
	rm -f irriga_comp lexer.c parser.c parser.h *.o *.mwasm
