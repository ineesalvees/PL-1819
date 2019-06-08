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
char * generateAudio(char * src,char * name);
void style();
char * navbar();
char * drawTitle(char * str);
char * UrlBackground;

int elemento = 1;
int n_slides;
FILE * fp;
%}
%union {char * str; char * sentence; int num;}
%token START END NEXT LAST LINK VIDEO HEAD BODY IMAGEM TD TH TAB ENDTAB TITULO BACKGROUND AUDIO
%token <str> WORD
%token <num> NUM
%token <sentence> SENTENCE
%type <str> generator Designacao Elementos Elemento Head Body Url Nome Conteudo Tabela Cabecalho Linhas Linha Coluna Titulo Multimedia

%%
generator : START Designacao Elementos END {printf("%s\n",$2);}

Elementos : Elemento
		  | Elementos NEXT Elemento
		  ;

Elemento : HEAD Head BODY Body {char * navb = navbar();
								fprintf(fp,"	<body style=\"background-image:url('%s');background-repeat: no-repeat; background-size:cover;\">\n		%s\n		%s\n	</body>\n</html>"
									,UrlBackground,navb,$4);
								fclose(fp);
								free(navb);
								}
		 | HEAD Head Titulo BODY Body {char * navb = navbar();
			 						   char * titulo = drawTitle($3);
									   fprintf(fp,"	<body style=\"background-image:url('%s');background-repeat: no-repeat; background-size:cover;\">\n		%s\n		%s%s\n	</body>\n</html>"
									   			,UrlBackground
												,navb
												,titulo
												,$5);
									   fclose(fp);
									   free(navb);
									   free(titulo);
								   	  }
		 ;

Body : Conteudo {$$=$1;}
	 | Body ';' Conteudo {asprintf(&$$,"%s%s",$1,$3);}
	 ;

Conteudo : Multimedia	{$$=$1;}
		 | Tabela	{$$=$1;}
		 ;


Multimedia : IMAGEM Nome Url {char * aux = generateImage($3,$2); asprintf(&$$,"%s",aux); free(aux);}
		   | VIDEO Nome Url {char * aux = generateVideo($3,$2); asprintf(&$$,"%s",aux); free(aux);}
		   | AUDIO Nome Url {char * aux = generateAudio($3,$2); asprintf(&$$,"%s",aux); free(aux);}
		   ;

Url : SENTENCE {$$=$1;}
	;

Nome : WORD {$$=$1;}
	 ;

Head : LAST			{openFile(1,0); elemento++;}
	 | LINK NUM		{openFile(0,$2); elemento++;}
	 ;

Designacao : '{' SENTENCE NUM '}' {diagrama_nome = strdup($2); mkdir(diagrama_nome,0700); n_slides = $3; UrlBackground = ""; asprintf(&$$,"%s-%d",$2,$3);}
           | '{' SENTENCE NUM BACKGROUND SENTENCE '}' {diagrama_nome = strdup($2); mkdir(diagrama_nome,0700); n_slides = $3; UrlBackground = strdup($5); asprintf(&$$,"%s-%d",$2,$3);}
		   ;

Tabela : TAB Cabecalho Linhas ENDTAB {asprintf(&$$,"<style>table, th, td { border: 1px solid black;} </style>\n<table style=\"display: block; margin-left: auto; margin-right: auto; width: 50%%\">%s%s</table>\n",$2,$3);}
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

Titulo : TITULO SENTENCE	{$$=$2;}
       ;

%%
#include "lex.yy.c"

char * generateVideo(char * src,char * name){
	char buffer[1024];
	sprintf(buffer,"<video width=\"800\" style=\"display: block; margin-left: auto; margin-right: auto;\"  controls>  <source src=\"%s\" type=\"video/mp4\"> </video>		<p style=\"text-align: center;\">%s</p>\n",src,name);
	return strdup(buffer);
}

char * generateImage(char * src,char * name){
	char buffer[1024];
	sprintf(buffer,"<img style=\"display: block; margin-left: auto; margin-right: auto; width: 50%%\" src=\"%s\"/>		<p style=\"text-align: center;\">%s</p>\n",src,name);
	return strdup(buffer);
}

char * generateAudio(char * src,char * name){
	char buffer[1024];
	sprintf(buffer,"<audio style=\"display: block; margin-left: auto; margin-right: auto;\"  controls>  <source src=\"%s\" type=\"video/mpeg\"> </audio>		<p style=\"text-align: center;\">%s</p>\n",src,name);
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
	style();
	fprintf(fp,"	</head>\n");

}

char * navbar(){
	char buffer[4096];
	char buffer2[1024];
	strcpy(buffer,"<div class=\"topnav\">\n");
	for(int i = 0; i <= n_slides; i++){
		if (elemento - 1 == i){
			sprintf(buffer2,"<a class=\"active\" href=\"p%d.html\">%d</a>\n",i,i);
		}
		else{
			sprintf(buffer2,"<a href=\"p%d.html\">%d</a>\n",i,i);
		}
		strcat(buffer,buffer2);
	}
	strcat(buffer,"</div>\n");

	return strdup(buffer);
}

char * drawTitle(char * str){
	char buffer[1024];
	sprintf(buffer,"		<h1 align=\"center\">%s</h1>\n",str);
	return strdup(buffer);
}

void style(){
	fprintf(fp,"%s","<style>body {margin: 0;font-family: Arial, Helvetica, sans-serif;}");
	fprintf(fp,"%s",".topnav {overflow: hidden;background-color: #333;}");
	fprintf(fp,"%s",".topnav a {float: left;color: #f2f2f2;text-align: center;padding: 14px 16px;text-decoration: none;font-size: 17px;}");
	fprintf(fp,"%s",".topnav a:hover {background-color: #ddd;color: black;}");
	fprintf(fp,"%s",".topnav a.active {background-color: #4CAF50;color: white;}</style>");
}

int main(){
    yyparse();
    return 0;
}

void yyerror(char* s){
    fprintf(stderr, "%s, '%s', line %d \n", s, yytext, yylineno);
}
