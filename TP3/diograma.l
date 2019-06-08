%{
#include "y.tab.h"
#include <ctype.h>
#include <string.h>
%}
%%

(?i:START) 				{return START;}
(?i:NEXT) 				{return NEXT;}
(?i:END) 				{return END;}
(?i:LINK)				{return LINK;}
(?i:LAST)				{return LAST;}
(?i:VIDEO)				{return VIDEO;}
(?i:BODY)				{return BODY;}
(?i:HEAD)				{return HEAD;}
(?i:IMAGEM)				{return IMAGEM;}
(?i:TD)					{return TD;}
(?i:TH)					{return TH;}
(?i:TAB)				{return TAB;}
(?i:ENDTAB)				{return ENDTAB;}
[a-zA-Z]+				{yylval.str = strdup(yytext); return WORD; }
[0-9]+      			{yylval.num = atoi(yytext); return NUM;}
[;\:|]					{return yytext[0];}
\'[^\n]+\'  			{yytext[yyleng-1] = '\0'; yylval.sentence = strdup(yytext+1); return SENTENCE; }
.|\n {;}
%%

int yywrap() {return 1;}