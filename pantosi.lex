%{
	#include <stdio.h>
	#define YY_DECL int yylex()
	#include "pantosi.tab.h"
%}

%option noyywrap

%%

"ls"       {return LS;}
"ps"       {return PS;}
"kill"     {return KILL;}
"mkdir"    {return MKDIR;}
"rmdir"    {return RMDIR;}
"cd"       {return CD;}
"touch"    {return TOUCH;}
"ifconfig" {return IFCONFIG;}
"start"    {return START;}
"quit"     {return QUIT;}

"+"        {return PLUS;}
"-"		   {return MINUS;}
"*"        {return TIMES;}
"/"        {return DIVIDED_BY;}
"("		   {return AP;}
")"		   {return FP;}

\n                                {return N;}
[0-9]*[a-zA-Z.~][a-zA-Z.~]*[0-9]* {yylval.text = (yytext); return STRING;}

"-"?[0-9]+\.[0-9]+                {yylval.f = atof(yytext); return FLOAT;}
"-"?[0-9]+			              {yylval.i = atoi(yytext); return INT;}
[ \t]                             {;}

%%
