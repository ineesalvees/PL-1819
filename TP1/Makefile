tp1: ex1.l ex2.l ex3.l
	 flex -o ex1.c ex1.l
	 gcc -g ex1.c -o ex1
	 flex -o ex2.c ex2.l
	 gcc ex2.c `pkg-config --cflags --libs glib-2.0` -o ex2
	 flex -o ex3.c ex3.l
	 gcc ex3.c `pkg-config --cflags --libs glib-2.0` -o ex3


clean:
	rm ex1 ex2 ex3
	rm *.c
