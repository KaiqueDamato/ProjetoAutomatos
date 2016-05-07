%{
	#include <stdio.h>
	#define YY_DECL int yylex()
	#include "pantosi.tab.h"
}%

%option noyywrap

%%

"ls"       {return LS;}
"ps"       {return PS;}
"kill"     {return KLL;}
"MKDIR"    {return MKDIR;}
"RMDIR"    {return RMDIR;}
"CD"       {return CD;}
"TOUCH"    {return TOUCH;}
"IFCONFIG" {return IFCONFIG;}
"START"    {return START;}
"QUIT"     {return QUIT;}

\n                 {return N;}
[a-zA-Z0-9().\/]+  {yyval.text = (yytext); return STRING;}

[0-9]+\.[0-9]+     {yyval.float = atof(yytext); return FLOAT;}
[0-9]+			   {yyval.int = atoi(yytext); return INT;}

%%
