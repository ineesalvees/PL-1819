%{
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

char * diagrama_nome;
int yylex();
void yyerror(char* c);
void openFile(int last,int time);
char * generateVideo(char * src,char * name);
char * generateImage(char * src,char * name);

int elemento = 1;
FILE * fp;
%}
%union {char * str; char * sentence; int num;}
%token START END NEXT LAST LINK VIDEO HEAD BODY IMAGEM TD TH TAB ENDTAB
%token <str> WORD
%token <num> NUM
%token <sentence> SENTENCE
%type <str> generator Designacao Elementos Elemento Head Body Video Url Nome Conteudo Imagem Tabela Cabecalho Linhas Linha Coluna

%%
generator : START Designacao Elementos END {printf("%s\n",$2);}

Elementos : Elemento
		  | Elementos NEXT Elemento
		  ;

Elemento : HEAD Head BODY Body {fprintf(fp,"	<body>\n		%s\n	</body>\n</html>",$4); fclose(fp);}
		 ;

Body : Conteudo {$$=$1;}
	 | Body ';' Conteudo {asprintf(&$$,"%s%s",$1,$3);}
	 ;

Conteudo : Video	{$$=$1;}
		 | Imagem	{$$=$1;}
		 | Tabela	{$$=$1;}
		 ;

Imagem : IMAGEM Nome Url {asprintf(&$$,"%s",generateImage($3,$2));}
	   ;

Video : VIDEO Nome Url {asprintf(&$$,"%s",generateVideo($3,$2));}
      ;

Url : SENTENCE {$$=$1;}
	;

Nome : WORD {$$=$1;}
	 ;

Head : LAST			{openFile(1,0);}
	 | LINK NUM		{openFile(0,$2); elemento++;}
	 ;

Designacao : WORD {diagrama_nome = strdup($1); mkdir(diagrama_nome,0700);}
		   ;

Tabela : TAB Cabecalho Linhas ENDTAB {asprintf(&$$,"<style>table, th, td { border: 1px solid black;} </style>\n<table>%s%s</table>\n",$2,$3);}
	   ;

Cabecalho : Linha			{asprintf(&$$,"<tr>%s</tr>\n",$1);};
		  ;

Linhas : Linha				{asprintf(&$$,"<tr>%s</tr>\n",$1);}
	   | Linhas ':' Linha	{asprintf(&$$,"%s%s",$1,$3);}
	   ;

Linha : Coluna 				{$$=$1;}
	  | Linha '|' Coluna	{asprintf(&$$,"%s%s",$1,$3);}
	  ;

Coluna : TD SENTENCE 		{asprintf(&$$,"<td>%s</td>\n",$2);}
	   | TH SENTENCE		{asprintf(&$$,"<th>%s</th>\n",$2);}
	   ;

%%
#include "lex.yy.c"

char * generateVideo(char * src,char * name){
	char buffer[1024];
	sprintf(buffer,"<video width=\"400\" height=\"400\"  controls>  <source src=\"%s\" type=\"video/mp4\"> </video>		<p>%s</p>\n",src,name);
	return strdup(buffer);
}

char * generateImage(char * src,char * name){
	char buffer[1024];
	sprintf(buffer,"<img width=\"100%%\" src=\"%s\"/>		<p>%s</p>\n",src,name);
	return strdup(buffer);
}

char * initTable(){
	char buffer[1024];
	strcpy(buffer,"<style>table, th, td { border: 1px solid black;} </style>");
	return strdup(buffer);
}

void openFile(int last,int time){
	char buffer[1024];
	sprintf(buffer, "%s/p%d.html",diagrama_nome,elemento);
	fp = fopen(buffer,"w+");
	fprintf(fp,"<html>\n	<head>\n		<meta charset=\"UTF-8\"/>\n");
	if (last != 1){
		sprintf(buffer, "		<meta http-equiv=\"REFRESH\" content=\"%d ;URL=p%d.html\">\n",time,elemento+1);
		fprintf(fp,"%s",buffer);
	}
	fprintf(fp,"	</head>\n");
}

int main(){
    yyparse();
    return 0;
}

void yyerror(char* s){
    fprintf(stderr, "%s, '%s', line %d \n", s, yytext, yylineno);
}
