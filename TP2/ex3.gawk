BEGIN	{FS=";";
		print "---- Exercício 3 ----"

        titulo = "<h1 align=\"center\"> Estatísticas para os Nomes Próprios  </h1>\n";

        tabela = "<tr> <td align="center"> %s </td><td align="center"> %d </td> </tr>";


        system("mkdir -p results/");
        ficheiro = "results/ex3.html";
		for(n=0; n < 256;n++) ascii[sprintf("%c",n)]=n;
}
		NR > 2 && ($2 ~/[A-Z][a-z]*( [a-zA-Z][a-z]*)*/) {split($2,data," "); for(i in data){ if (ascii[substr(data[i],1,1)] < 97) {conta[data[i]]++;} } }
		NR > 2 && ($7 ~/[A-Z][a-z]*( [a-zA-Z][a-z]*)*/) {split($7,data," "); for(i in data){ if (ascii[substr(data[i],1,1)] < 97) {conta[data[i]]++;} } }
		NR > 2 && ($9 ~/[A-Z][a-z]*( [a-zA-Z][a-z]*)*/) {split($9,data," "); for(i in data){ if (ascii[substr(data[i],1,1)] < 97) {conta[data[i]]++;} }}
		NR > 2 && ($11 ~/[A-Z][a-z]*( [a-zA-Z][a-z]*)*/) {split($11,data," "); for(i in data){ if (ascii[substr(data[i],1,1)] < 97) {conta[data[i]]++;} }}


END {
		header = "<html> <head> <meta charset='UTF-8'/> <style>table, th, td {border: 1px solid black; border-collapse: collapse;} th, td {padding: 5px;} th {text-align: center;}</style> </head> <body>";

		print header > ficheiro;
		print titulo > ficheiro;

        printf("<table style=\"width:30%\"><tr> <th>%s</th><th>Nº de ocurrências</th> </tr>","Nome Próprio") > ficheiro;
		for(nome in conta){
			printf (tabela,nome,conta[nome]) > ficheiro;
		}
		print "</table>" > ficheiro;

		print "</body> </html>" > ficheiro;
	}
