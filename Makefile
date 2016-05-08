all: shell

bison.tab.c bison.tab.h: pantosi.y
	bison -d pantosi.y

lex.yy.c: pantosi.lex bison.tab.h
	flex pantosi.lex

shell: lex.yy.c bison.tab.c bison.tab.h
	gcc -o pantosiShell pantosi.tab.c lex.yy.c -lfl

clean:
	rm pantosiShell pantosi.tab.c lex.yy.c pantosi.tab.h