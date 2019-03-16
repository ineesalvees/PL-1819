%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

%}
lixo (â\”)
%%
Ã³ {printf("ó");}
Ã§ {printf("ç");}
Ãº {printf("ú");}
Ãª {printf("ê");}
Ã© {printf("é");}
Ãµ {printf("õ");}
Ã¡ {printf("á");}
Ã£ {printf("ã");}
Ã¢ {printf("â");}
Ã\  {printf("à");}
Ã {printf("í");}
â€\” {printf("-");}
â€œ {printf("“");}
â€ {printf("”");}
â€\“ {;}
(\.)?Âº {printf("º");}
{lixo}+ {;}
%%
int yywrap(){ return 1; }
int main(){
    yylex();
    return 0;
}
