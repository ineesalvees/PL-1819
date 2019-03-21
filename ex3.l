%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmodule.h>
#include <ctype.h>

FILE * fp;
GTree * tags;
char * nstr;

gboolean imprimir_tag(gpointer key, gpointer value, gpointer data);
void insereTag(char * tag);
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
    fp = fopen(argv[1],"w+");
    yylex();
    g_tree_foreach(tags, imprimir_tag, NULL);
    return 0;
}

gboolean imprimir_tag(gpointer key, gpointer value, gpointer data){
    fprintf(fp,"%s -> %d\n",key,*((int *)value));
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

