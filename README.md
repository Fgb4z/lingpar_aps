# IRRIGA — EBNF 

## Objetivo

Linguagem de alto nível para controlar um sistema de irrigação por zonas em uma VM. Permite acionar válvulas e bomba, aplicar atrasos e ler sensores (umidade por zona, chuva, cisterna, relógio, sol, vazão).

```
[G1] program      ::= { stmt } ;

[G2] stmt         ::= assign
                    | if_stmt
                    | while_stmt
                    | command
                    ;

[G3] assign       ::= ident "=" expr ";" ;

[G4] if_stmt      ::= "if" "(" bexpr ")" block
                      [ "else" block ] ;

[G5] while_stmt   ::= "while" "(" bexpr ")" block ;

[G6] block        ::= "{" { stmt } "}" ;

[G7] command      ::= actuator_cmd ";"
                    | sensor_read  ";"
                    ;

[G8] actuator_cmd ::= "valvula_on"  "(" expr ")"
                    | "valvula_off" "(" expr ")"
                    | "bomba_on"
                    | "bomba_off"
                    | "delay" "(" expr ")"
                    ;

[G9] sensor_read  ::= "ler" "(" sensor_base [ "," expr ] ")" "->" ident ;

[G10] expr        ::= term { ("+" | "-" | "*" | "/") term } ;
[G11] term        ::= number | ident | "(" expr ")" ;

[G12] bexpr       ::= rel { ("and" | "or") rel } ;
[G13] rel         ::= expr relop expr ;
[G14] relop       ::= "==" | "!=" | ">" | "<" | ">=" | "<=" ;

[G15] sensor_base ::= "umidade" | "chuva" | "cisterna" | "relogio" | "sol" | "vazao" ;

[G16] ident       ::= letter { letter | digit | "_" } ;
[G17] number      ::= digit { digit } ;
```


## Características

* Variáveis inteiras.
* `if/else` e `while`.
* Comandos: `valvula_on(z)`, `valvula_off(z)`, `bomba_on`, `bomba_off`, `delay(ms)`.
* Sensores somente leitura:

  * `ler(umidade, z) -> x` (0..100)
  * `ler(chuva) -> x` (0/1)
  * `ler(cisterna) -> x` (0..100)
  * `ler(relogio) -> x` (0..1439)
  * `ler(sol) -> x` (lux)
  * `ler(vazao, z) -> x` (ml/min)

## Exemplo

```
ler(cisterna) -> c;
ler(chuva) -> ch;
ler(relogio) -> t;

if (t >= 330 and t <= 420) {
    z = 0;
    while (z < 4) {
        ler(umidade, z) -> u;
        if (u < 40 and ch == 0 and c > 20) {
            bomba_on;
            valvula_on(z);
            delay(180000);
            valvula_off(z);
            bomba_off;
        }
        z = z + 1;
    }
}
```



