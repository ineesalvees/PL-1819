BEGIN	{FS=";";
		print "---- Exercício 2 ----"

        titulo = "<h1 align=\"center\"> Processos por ano e os seu concelhos  </h1>\n";

        linha = "<h3> %s </h3>\n";

        tabela = "<tr> <td align="center"> %s </td><td align="center"> %d </td> </tr>";


        system("mkdir -p results/");
        system("mkdir -p results/Ano/");
        ficheiro = "results/ex2.html";

}
		# Datas
		NR > 2 && ($6 ~/[0-9]*\.[0-9]*\.[0-9]/) {split($6,data,"."); conta[data[1]][$5]++; concelhos[$5]++;}
		NR > 2 && ($6 ~/[0-9]*\/[0-9]*\/[0-9]/) {split($6,data,"/"); conta[data[3]][$5]++; concelhos[$5]++;}
		NR > 2 && ($6 ~/[0-9]*-[0-9]*-[0-9]/) {split($6,data,"-"); conta[data[1]][$5]++; concelhos[$5]++;}


END {
		header = "<html> <head> <meta charset='UTF-8'/> <style>table, th, td {border: 1px solid black; border-collapse: collapse;} th, td {padding: 5px;} th {text-align: center;}</style> </head> <body>";

		print header > ficheiro;
		print titulo > ficheiro;

		printf(linha,"Anos","") > ficheiro;
		print "<ul>" > ficheiro;
		for (key in conta) {
			ficheiroAno = "results/Ano/freq" key ".html";
			print "<li>" "<a href=\"Ano/freq" key ".html" "\"/>Ano " key"</li>" > ficheiro;
			print header > ficheiroAno;
			print "<h1 align=\"center\"> Processos do Ano " key "  </h1>\n" > ficheiroAno;
			printf("<table style=\"width:30%\"><tr> <th align="center">%s</th><th align="center">N.º de processos registados por concelho</th> </tr>","Concelho") > ficheiroAno;
			for (concelho in conta[key]) {
				printf (tabela,concelho,conta[key][concelho]) > ficheiroAno;
			}
			print "</table>" > ficheiroAno;
			print "</body> </html>" > ficheiroAno;
		}
		print "</ul>" > ficheiro;

		print "</body> </html>" > ficheiro;
	}
