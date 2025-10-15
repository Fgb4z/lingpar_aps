FL_LIB := $(shell test -f /opt/homebrew/opt/flex/lib/libfl.a && echo /opt/homebrew/opt/flex/lib/libfl.a || echo -lfl)

.PHONY: all run clean

all: irriga_chk

irriga_chk: parser.c lexer.c
	@gcc -O2 -std=c11 -Wall -Wextra -pedantic -o irriga_chk lexer.c parser.c $(FL_LIB)
	@echo "✅ Compilação concluída!"

parser.c parser.h: parser.y
	@bison -d -o parser.c parser.y

lexer.c: lexer.l parser.h
	@flex -o lexer.c lexer.l

run: all
	@if [ -f exemplo.irriga ]; then \
	  echo "▶  Executando irriga_chk..."; \
	  ./irriga_chk < exemplo.irriga; \
	else \
	  echo "⚠  Arquivo exemplo.irriga não encontrado. Crie um e rode 'make run' novamente."; \
	fi

clean:
	rm -f irriga_chk lexer.c parser.c parser.h *.o