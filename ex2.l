%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmodule.h>


FILE *fp;
char buffer_post [24*1024];
GTree * tags;
GTree * posts;

void inithtml(char * file_name);
void insertTagsLink(char * tag);
void bufferclose();
void endhtml();
void createIndex();
int searchPost(char * str);

%}
%x PUB
%x TAGS
%x TEXT
%x DISCARD
%%

\<pub\  {BEGIN PUB;}
<PUB>id=\"[^\"]+ {if (searchPost(yytext+4)) {inithtml(yytext+4);} else {BEGIN DISCARD;}}
<PUB>\<title\>[^\<]+ {strcat(buffer_post,yytext+7); bufferclose(); fprintf(fp, "%s",yytext+7);}
<PUB>\<\/pub\> {buffer_post[0]='\0';endhtml(); BEGIN INITIAL;}
<PUB>\<tags\> {fprintf(fp,"<b>Tags: </b>\n\t<ul>"); BEGIN TAGS;}
<TAGS>\<\/tags\> {fprintf(fp,"</ul>"); BEGIN PUB;}
<TAGS>\<tag\>[^\<]+ {fprintf(fp,"<li>%s",yytext); insertTagsLink(yytext+5);}
<TAGS>\<\/tag\> {fprintf(fp, "</li>");}
<PUB>\<author_date\> {fprintf(fp, "<p><b>Data: </b>");}
<PUB>\<\/author_date\> {fprintf(fp, "</p>");}
<PUB>\<category\> {fprintf(fp, "<p><b>Categoria: </b>");}
<PUB>\<\/category\> {fprintf(fp, "</p>");}
<PUB>\<text\> {fprintf(fp, "<p>"); BEGIN TEXT;}
<TEXT>\.[\n]+ {fprintf(fp, ".</p><p>");}
<TEXT>\n[\n]+ {fprintf(fp, "</p><p>");}
<TEXT>\<\/text\> {fprintf(fp, "</p>"); BEGIN PUB;}
<DISCARD>.|\n {;}
<DISCARD>\<\/pub\> {BEGIN INITIAL;}


<*>.|\n {fprintf(fp,"%s",yytext);}
%%
int yywrap(){ return 1; }
int main(int argc, char* argv[]){

	tags = g_tree_new((GCompareFunc)strcmp);
	posts = g_tree_new((GCompareFunc)strcmp);
    yylex();
	createIndex();
    return 0;
}

void inithtml(char * file_name){
	char buffer [1024];
	strcpy(buffer,"html/");
	strcat(buffer,file_name);
	strcat(buffer,".html");
	fp = fopen(buffer,"w+");
	fprintf(fp,"<HTML> <BODY> <meta charset='UTF-8'/>");
	fprintf(fp, "<pub id=\"%s",file_name);

	strcpy(buffer_post,"<BR><A HREF=\"");
	strcat(buffer_post,file_name);
	strcat(buffer_post,".html\">");
}

void insertTagsLink(char * tag){
	GSList * list = g_tree_lookup(tags,tag);
	char * str = strdup(buffer_post);
	char * key = strdup(tag);

	list = g_slist_prepend(list,str);
	g_tree_insert(tags,key,list);
}

void bufferclose(){
	strcat(buffer_post,"</A><BR>");
}

void printList(gpointer data,gpointer user_data){
	fprintf(fp,"%s\n",(char *)data);
}

gboolean printTreeLinks(gpointer key, gpointer value, gpointer data){
	GSList * v = (GSList *) value;
	char * str = (char *) key;

	fprintf(fp, "<LI>");
	fprintf(fp,"%s",key);

	g_slist_foreach(v,printList,NULL);
	fprintf(fp, "</LI>\n");

	return FALSE;
}

void endhtml(){
	fprintf(fp,"</BODY> </HTML>");
	fclose(fp);
}


void createIndex(){
	fp = fopen("html/index.html","w+");
	fprintf(fp,"<HTML> <BODY> <meta charset='UTF-8'/>\n");
	fprintf(fp, "<UL>\n");
	g_tree_foreach(tags,printTreeLinks,NULL);
	fprintf(fp, "</UL>\n");
	endhtml();
}

int searchPost(char * str){
	char * post_id = strdup(str);
	int * i = g_tree_lookup(posts,post_id);
	if (i == NULL){
		i = malloc(sizeof(int));
		g_tree_insert(posts,post_id,i);
		return 1;
	}
	else{
		return 0;
	}
}
