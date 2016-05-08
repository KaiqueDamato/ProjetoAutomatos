%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/types.h>
	#include <unistd.h>

	extern int yylex();
	extern int yyparse();
	extern FILE* yyin;

void yyerror(const char* s);
void newCommand();
int error = 0;
%}

%union {
	int i;
	float f;
	char c;
	char* text;
}

%token LS
%token PS
%token KLL
%token MKDIR
%token RMDIR
%token CD
%token TOUCH
%token IFCONFIG
%token START
%token QUIT
%token N
%token STRING
%token PLUS
%token MINUS
%token TIMES
%token DIVIDED_BY

%token<i> INT
%token<f> FLOAT

%type<c> pchar
%type<text> STRING
%type<i>expression
%type<f>floatExpression
%type<i>term
%type<f>floatTerm

%start pantosiShell

%%

pantosiShell:
	| pantosiShell line
;

line: N
	| pchar N           {newCommand();}
	| expression N      {if(error == 0) printf("%d", $1); newCommand(); error = 0;}
	| floatExpression N {if(error == 0) printf("%f", $1); newCommand(); error = 0;}
;

expression: expression PLUS term       {$$ = $1 + $3;}
	|       expression MINUS term      {$$ = $1 - $3;}
	|       expression TIMES term      {$$ = $1 * $3;}
	|       expression DIVIDED_BY term {if($3 != 0) $$ = $1 / $3; else {error = 1; printf("erro, nao existe divisao por zero");}}
	|       term 			           {$$ = $1;}
;

floatExpression: floatExpression PLUS floatTerm       {$$ = $1 + $3;}
	|	         floatExpression MINUS floatTerm      {$$ = $1 - $3;}
	|			 floatExpression TIMES floatTerm      {$$ = $1 * $3;}
	|			 floatExpression DIVIDED_BY floatTerm {if($3 != 0) $$ = $1 / $3; else {error = 1; printf("erro, nao existe divisao por zero");}}
	|			 floatTerm					          {$$ = $1;}
;

term:  INT {$$ = $1;}
;

floatTerm: FLOAT {$$ = $1;}
;

pchar: LS           {printf("Teste LS");}
	|  PS     		{printf("Teste PS");}
	|  KLL STRING	{printf("Teste KLL");}
	|  MKDIR STRING {printf("Teste MKDIR");}
	|  RMDIR STRING	{printf("Teste RMDIR");}
	|  CD STRING	{printf("Teste CD");}
	|  TOUCH STRING	{printf("Teste TOUCH");}
	|  START STRING {printf("Teste START");}
	|  QUIT 		{exit(0);}
;

%%

int main() {
	yyin = stdin;

	newCommand();

	do{
		yyparse();
	}while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	printf("Comando invalido %s", s);
	newCommand();
}

void newCommand() {
	char cwd[1024];
	if (getcwd(cwd, sizeof(cwd)) != NULL)
		printf("\npantosiShell:%s ", cwd);
	else
		perror("getcwd() error");
}
