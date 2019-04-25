BEGIN	{FS=";";
		print "---- Exercício 4 ----";
        system("mkdir -p results/");
        ficheiro = "results/ex4.dot";
}
		NR > 2 && ($2 ~/[A-Z][a-z]*( [a-zA-Z][a-z]*)*/) {nomes[$2]++;}
		NR > 2 && ($7 ~/[A-Z][a-z]*( [a-zA-Z][a-z]*)*/) {pai[$2] = $7;}
		NR > 2 && ($9 ~/[A-Z][a-z]*( [a-zA-Z][a-z]*)*/) {mae[$2] = $9;}
		NR > 2 && ($11 ~/[A-Z][a-z]*( [a-zA-Z][a-z]*)*/) {conjuge[$2] = $11;}

END {
	print "digraph g {" > ficheiro;

	print "rankdir=LR;" > ficheiro;
	for(nome in nomes){
		if (nome in pai){
			print "\"" pai[nome] "\"->\""  nome "\"" "[label=\"pai de\"];" > ficheiro;
		}
		if (nome in mae){
			print "\"" mae[nome] "\"->\""  nome "\"" "[label=\"mae de\"];" > ficheiro;
		}
		if (nome in conjuge){
			print "\"" nome "\"->\"" conjuge[nome] "\"" "[label=\"conjuge\"];" > ficheiro;
		}
	}
	print "}" > ficheiro;
}
