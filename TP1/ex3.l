%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmodule.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <ctype.h>

FILE * fp;
GTree * tags;
char * nstr;

gboolean imprimir_tag(gpointer key, gpointer value, gpointer data);
void insereTag(char * tag);
void initTable();
%}
%x TAG
%%
#TAG: {BEGIN TAG;}
<TAG>tag:\{[^\}]+\} {nstr=strdup(yytext+5); nstr[yyleng-6]='\0'; insereTag(nstr);}
<TAG>\n {BEGIN INITIAL;}
<*>.|\n {;}
%%
int yywrap(){ return 1; }
int main(int argc, char* argv[]){

    tags = g_tree_new((GCompareFunc)strcmp);
	mkdir("html",0700);
    fp = fopen("html/estatisticas.html","w+");
    yylex();

	fprintf(fp, "<HTML> <BODY> <meta charset='UTF-8'/>");
	initTable();
    g_tree_foreach(tags, imprimir_tag, NULL);
	fprintf(fp, "</table>");
	fprintf(fp,"</BODY> </HTML>");
	fclose(fp);
    return 0;
}

gboolean imprimir_tag(gpointer key, gpointer value, gpointer data){
	fprintf(fp, "<tr>");
	fprintf(fp, "<td>%s</td>\n",key);
	fprintf(fp, "<td>%d</td>",*((int *)value));
	fprintf(fp, "</tr>");

    return FALSE;
}

void insereTag(char * tag){
    gpointer value = g_tree_lookup(tags,tag);
    int * i;
    if (value == NULL){
        i = (int *) malloc(sizeof(int));
        *i = 1;
        g_tree_insert(tags,(gpointer)tag,(gpointer)i);
    }
    else{
        i = (int *) value;
        int k = *i;
		k++;
		(*i) = k;
    }
}

void initTable(){
	fprintf(fp, "<style>table, th, td { border: 1px solid black;} </style>");
	fprintf(fp, "<table>");
	fprintf(fp, "<tr>");
	fprintf(fp, "<th>Tag</th>");
	fprintf(fp, "<th>Número de Ocorrências</th>");
	fprintf(fp, "</tr>");
}
