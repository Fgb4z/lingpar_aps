@echo off
echo Gerando parser...
bison -d -o parser.c parser.y
if errorlevel 1 goto error

echo Gerando lexer...
flex -o lexer.c lexer.l
if errorlevel 1 goto error

echo Compilando irriga_comp...
gcc -O2 -std=c11 -Wall -Wextra -pedantic -o irriga_comp main.c lexer.c parser.c
if errorlevel 1 goto error

echo.
echo Compilacao concluida!
goto end

:error
echo.
echo Erro na compilacao!
exit /b 1

:end
