CC=gcc
LEX=flex
YACC=bison
CFLAGS=-O2 -std=c11 -Wall -Wextra -pedantic


all: irriga_chk


parser.c parser.h: parser.y
$(YACC) -d -Wall -Wcounterexamples -o parser.c parser.y


lexer.c: lexer.l parser.h
$(LEX) -o lexer.c lexer.l


irriga_chk: lexer.c parser.c main.c
$(CC) $(CFLAGS) -o irriga_chk lexer.c parser.c main.c


clean:
rm -f irriga_chk lexer.c parser.c parser.h *.o