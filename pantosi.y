%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/types.h>
	#include <unistd.h>
	#include <sys/stat.h>
	#include <signal.h>

	extern int yylex();
	extern int yyparse();
	extern FILE* yyin;

void yyerror(const char *s);
void newCommand();
void pmkdir(char *dir);
void prmdir(char *dir);
void pstart(char *program);
void pkill(int i);
void ptouch(char *file);
void floatDivision(float a, float b);
void intDivision(int a, int b);

int error = 0;
int errorCount = 0;
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
	| pantosiShell line {errorCount = 0;}
;

line: N
	| pchar N           {newCommand();}
	| expression N      {
		             		if(error == 0 && errorCount == 0) { 
		             			printf("%d\n", $1); 
		             			newCommand();
		             		} 
		             		error = 0;
				        }
	| floatExpression N {
		                	if(error == 0 && errorCount == 0) { 
		                		printf("%f\n", $1); 
		                		newCommand();
		                	}
		                	error = 0;
                     	}
;

expression: term 			           {$$ = $1;}
	|       expression PLUS term       {$$ = $1 + $3;}
	|       expression MINUS term      {$$ = $1 - $3;}
	|       expression TIMES term      {$$ = $1 * $3;}
	|       expression DIVIDED_BY term {
											if($3 != 0) 
												$$ = $1 / $3; 
											else {
												error = 1; 
												printf("erro, nao existe divisao por zero\n"); 
												newCommand();
											}
									   }
;

floatExpression: floatTerm					          {$$ = $1;}
	|			 floatExpression PLUS floatTerm       {$$ = $1 + $3;}
	|	         floatExpression MINUS floatTerm      {$$ = $1 - $3;}
	|			 floatExpression TIMES floatTerm      {$$ = $1 * $3;}
	|			 floatExpression DIVIDED_BY floatTerm {
												      		if($3 != 0) 
																$$ = $1 / $3; 
															else {
																error = 1; 
																printf("erro, nao existe divisao por zero\n"); 
																newCommand();
															}
													  }
;

term:  INT {$$ = $1;}
;

floatTerm: FLOAT {$$ = $1;}
;

pchar: LS           {system("/bin/ls");}
	|  PS     		{system("/bin/ps");}
	|  KLL INT	    {pkill($2);}
	|  MKDIR STRING {pmkdir($2);}
	|  RMDIR STRING	{prmdir($2);}
	|  CD STRING	{printf("Teste CD");}
	|  TOUCH STRING	{ptouch($2);}
	|  IFCONFIG     {system("ifconfig");}
	|  START STRING {pstart($2);}
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
	if(errorCount == 0) {
		fprintf(stderr, "Comando invalido %s\n", s);
		newCommand();
	}
	errorCount++;
}

void newCommand() {
	char cwd[1024];
	if (getcwd(cwd, sizeof(cwd)) != NULL)
		printf("pantosiShell:%s ", cwd);
	else
		perror("getcwd() error");
}

void pmkdir(char *dir) {
	struct stat st = {0};

	if(stat(dir, &st) == -1)
		mkdir(dir, 0700);
	else
		printf("mkdir: impossivel criar o diretorio \"%s\": Arquivo existe\n", dir);
}

void prmdir(char *dir) {
	struct stat st = {0};

	if(stat(dir, &st) == 0)
		rmdir(dir);
	else
		printf("rmdir: falhou em remover \"%s\": Arquivo ou diretorio nao encontrado\n", dir);
}

void pstart(char *program) {
	char str[256];
	snprintf(str, sizeof str, "%s&", program);

	if(fork() == 0) {
		system(str);
		exit(0);
	}
}

void pkill(int i) {
	char str[100];
	sprintf(str, "%d", i);
	int status = kill(atoi(str), SIGKILL);
	if(status == -1) {
		printf("kill: (%d) - Processo inexistente ou operacao nao permitida\n", i);
	}
}

void ptouch(char *file) {
	char command[256];
	snprintf(command, sizeof command, "touch -am -t 200005050000 %s", file);
	system(command);
}
