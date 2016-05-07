all: shell

bison.tab.c bison.tab.h: pantosi.y
	pantosi -d pantosi.y

lex.yy.c: pantosi.flex pantosi.tab.h
	flex pantosi.lex

shell: lex.yy.c pantosi.tab.c pantosi.tab.h
	gcc -o pantosiShell pantosi.tab.c lex.yy.c -lfl

clean:
	rm pantosiShell pantosi.tab.c lex.yy.c pantosi.tab.h