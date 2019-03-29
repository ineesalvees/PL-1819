%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char tags_buffer[1024*4];
char category_buffer[1024*4];
char title_buffer[1024*4];
FILE *fp;

void initbuffers();

%}
FINISH (\<\/pub\>)
%x TAG
%x CATEGORY
%x TITLE
%x ID
%x TEXT
%x DATE
%%
\<pub\> {fprintf(fp,"<pub ");}
#TAG: {BEGIN TAG; strcpy(tags_buffer,"   <tags>\n     ");}
<TAG>tag:\{[^\}]+\} {yytext[yyleng-1]='\0'; strcat(tags_buffer,"<tag>"); strcat(tags_buffer,yytext+5); strcat(tags_buffer,"</tag> ");}
<TAG>\n {strcat(tags_buffer,"\n   </tags>\n"); BEGIN INITIAL;}
<TAG>. {;}
#ID:\{[^ ]+\  {yytext[yyleng-1]='\0';fprintf(fp,"id=\"%s\">\n",yytext+5); BEGIN ID;}
<ID>\}\n {BEGIN CATEGORY;}
<ID>.|\n {;}
<CATEGORY>.+\n {yytext[yyleng-1]='\0'; strcpy(category_buffer,"   <category>"); strcat(category_buffer,yytext); strcat(category_buffer,"</category>\n"); BEGIN TITLE;}
<TITLE>\n(.*?)\n\n {yytext[yyleng-2]='\0'; strcpy(title_buffer,"   <title>");strcat(title_buffer,yytext+1); strcat(title_buffer,"</title>\n"); BEGIN INITIAL;}
<TITLE>[━]+\n {strcpy(title_buffer,"   <title>");strcat(title_buffer,"Sem título.");strcat(title_buffer,"</title>\n"); BEGIN INITIAL;}
#DATE: {BEGIN DATE;}
<DATE>\]\ [^\n]+ {fprintf(fp,"%s",title_buffer); fprintf(fp,"   <author_date>");fprintf(fp,"%s",yytext+2); fprintf(fp,"</author_date>\n"); fprintf(fp,"%s",tags_buffer); fprintf(fp,"%s",category_buffer); fprintf(fp,"   <text>"); BEGIN TEXT;}
<TEXT>Etiquetas:[^\n]+ {;}
<TEXT>.|\n {fprintf(fp,"%s",yytext);}
<TEXT>(\<\/pub\>) {fprintf(fp,"%s","   </text>\n");fprintf(fp,"%s\n",yytext); initbuffers(); BEGIN INITIAL;}
<*>\n\n(\n)+ {fprintf(fp,"\n");}
<*>.|\n {;}
%%
int yywrap(){ return 1; }
int main(int argc, char* argv[]){

    fp = fopen(argv[1],"w+");
    yylex();
    return 0;
}

void initbuffers(){
    strcpy(tags_buffer,"");
    strcpy(category_buffer,"");
    strcpy(title_buffer,"");
}
