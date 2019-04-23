BEGIN{FS="[;]+";  print "---- ex1 ----"

            titulo = "<h1 align=\"center\"> Número de processos registados por Concelho e Freguesia </h1>\n";

            linha = "<h3> %s </h3> <p> %s </p>\n";

            tabela = "<tr> <td align="center"> %s </td><td align="center"> %d </td> </tr>";

            ficheiro = "index.html"          
    }
            
            NR > 2 {conta[$4][$3]++}

END {
    print "<html><body>" > ficheiro;
    for(concelho in conta){
        print "<a href=\"" concelho ".html\">" concelho "</a>" "<br>">> ficheiro;

        printf(linha,concelho,"") > ficheiro;
                printf("<table style=\"width:30%\"><tr> <th>%s</th><th>N.º de processos registados por freguesia</th> </tr>","Freguesia") > ficheiro;

                for (freguesia in conta[concelho])
                        printf (tabela,freguesia,conta[concelho][freguesia]) > ficheiro;

                print "</table>" > ficheiro;

    }
    
    print "\n<hr>\n" > ficheiro;

        printf(linha,"Concelhos","") > ficheiro;
        printf("<table style=\"width:30%\"><tr> <th align="center">%s</th><th align="center">N.º de processos registados por concelho</th> </tr>","Concelho") > ficheiro;

        for (concelho in conta){
                r = 0
                for (freguesia in conta[concelho])
                        r+=conta[concelho][freguesia]
                printf (tabela, concelho, r) > ficheiro;
        
        };
        printf (tabela,"Total:", NR-2) > ficheiro;

        print "</table>" > ficheiro;
        print "</body> </html>" > ficheiro;

    }
