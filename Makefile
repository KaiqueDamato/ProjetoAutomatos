all: clean shell

bison.tab.c: pantosi.y
	bison -d pantosi.y

lex.yy.c: pantosi.lex
	flex pantosi.lex

shell: bison.tab.c lex.yy.c 
	gcc -o pantosiShell pantosi.tab.c lex.yy.c -lfl

clean:
	rm -rf pantosiShell pantosi.tab.c lex.yy.c pantosi.tab.h