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
%token SUM

%token<i> INT
%token<f> FLOAT

%type<c> pchar
%type<text> STRING
%type<i>expression
%type<i>term

%start pantosiShell

%%

pantosiShell:
	| pantosiShell line
;

line: N
	| pchar N {newCommand();}
	| expression N {printf("%d", $1); newCommand();}
;

expression: expression SUM term {$$ = $1 + $3;}
	|       term 			    {$$ = $1;}

term:  INT    {$$ = $1;}
	|  FLOAT  {$$ = $1;}
;

pchar: LS               {printf("Teste LS");}
	|  PS     			{printf("Teste PS");}
	|  KLL STRING		{printf("Teste KLL");}
	|  MKDIR STRING   	{printf("Teste MKDIR");}
	|  RMDIR STRING		{printf("Teste RMDIR");}
	|  CD STRING		{printf("Teste CD");}
	|  TOUCH STRING		{printf("Teste TOUCH");}
	|  START STRING		{printf("Teste START");}
	|  QUIT 			{exit(0);}
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