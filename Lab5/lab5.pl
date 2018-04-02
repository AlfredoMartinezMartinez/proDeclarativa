%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     PARÁMETROS DE ACUMULACIÓN Y EFICIENCIA                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*************************************************
Ejercicio 17.
Sean P1 y P2 dos programas que implementan una misma especificación, es decir, pueden considerarse semánticamente equivalentes. Si el  programa P1 se ejecuta en un tiempo T1 y el programa P2 en un tiempo T2, el speedup S de P1 con respecto a P2 se define como: S=T2/T1.
Implementar un predicado speedup(S, G1, G2) que calcule el speedup S de un programa Prolog P1, en el que se lanza el objetivo G1, con respecto al programa P2, en el que se lanza el objetivo G2.
**************************************************/

speedup(S, G1, G2):- TT1 is  cputime,
		     G1,
		     TT2 is  cputime,
		     T1 is TT2 - TT1, % tiempo utilizado en ejecutar G1
		     TTT1 is  cputime,
		     G2,
		     TTT2 is  cputime,
		     T2 is TTT2 - TTT1,  % tiempo utilizado en ejecutar G2
		     (T1 =:= 0.0 ->
		     		write('Tiempo utilizado al ejecutar el objetivo 1: '),
		     		write(T1),
		     		nl,
		     		write('Tiempo utilizado al ejecutar el objetivo 2: '),
		     		write(T2),
		     		nl,
		     		S = infinito;
		     		write('Tiempo utilizado al ejecutar el objetivo 1: '),
		     		write(T1),
		     		nl,
		     		write('Tiempo utilizado al ejecutar el objetivo 2: '),
		     		write(T2),
		     		nl,
		     		S is T2/T1,
		     		write('Speedup: '),
		     		write(S),
		     		nl
		     ).



/*************************************************
Ejercicio 18.
La relación “invertir una lista” se puede definir de forma directa en términos del predicado append:
*************************************************/

% invertir(L,I), I es la lista que resulta de invertir L
invertir1([],[]).
invertir1([H|T],L) :- invertir1(T,Z), append(Z,[H],L).

/*************************************************
El problema con esta versión es que es muy ineficiente debido a que  el número de llamadas al operador “[.|..]” es cuadrático con respecto al número de elementos de la lista que se está invirtiendo, si también contamos las llamadas al operador “[.|..]” producidas por una llamada al predicado append. Se puede lograr que el número de llamadas al operador  “[.|..]” sea lineal  con respecto al número de elementos de la lista  utilizando un parámetro de acumulación. Un parámetro de acumulación es un argumento de un predicado que, como indica su nombre, se utiliza para almacenar resultados intermedios. En el caso que nos ocupa, se almacena la lista que acabará por ser la lista invertida, en sus diferentes fases de construcción.
*************************************************/

% invertir2(L,I), I es la lista que resulta de invertir L
% Usando un parametro de acumulacion.
invertir2(L,I) :- inv(L, [], I).
% inv(Lista, Acumulador, Invertida)
inv([], I, I).
inv([X|R], A, I) :- inv(R, [X|A], I).

/*************************************************
Medir el speedup del programa “invertir2” con respecto al programa “invertir1”. Compare también la eficiencia de estos programas con respecto al predicado predefinido “reverse”. (Ayuda: definir un predicado capaz de generar una lista de miles de elementos.)


(Observación: En el libro PROGRAMACIÓN LÓGICA, TEORÍA Y PRÁCTICA, de María Alpuente y Pascual Julián, página 193, puede encontrar más información sobre este ejercicio y el uso de parámetros de acumulación.)
*************************************************/


/*************************************************
Ejercicio 19.
La siguiente definición de “longitud1” es una versión ingenua que permite calcular la longitud de una lista:
*************************************************/

% longitud1(L,N), N es la longitud de la lista L
longitud1([],0).
longitud1([_|T],N) :- longitud1(T,Z), N is Z+1.

/*************************************************
Utilizando parámetros de acumulación, definir una versión “longitud2(L,N)” más eficiente.
*************************************************/

% longitud2(L,N), N es la longitud de la lista L

longitud2(L,N) :- longitud2(L,N,0).

longitud2([],A,A).
longitud2([_|T],N,A):- NextA is A +1, longitud2(T,N,NextA).

/*************************************************
Medir el speedup del programa “longitud2” con respecto al programa “longitud1”. Compare también la eficiencia de estos programas con respecto al predicado “length” predefinido en Prolog.
(Ayuda: definir un predicado capaz de generar una lista de miles de elementos.)
*************************************************/

/*************************************************
Ejercicio 20.
La siguiente definición de “suma1” es una versión ingenua que permite calcular la suma de los elementos de una lista de enteros:
*************************************************/

%% suma1(L,N), N es  la suma de los elementos de una lista de enteros.
suma1([],0).
suma1([H|T],N) :- suma1(T,Z), N is Z+H.

/*************************************************
Utilizando parámetros de acumulación, definir una versión “suma2(L,N)” más eficiente.
*************************************************/

suma2(L, S) :- suma2(L, 0, S).

% suma2(L, A, S)
% A es un par\'ametro de acumulaci\'on.
% Recorre la lista L y va sumando los elementos con el par\'ametro
% de acumulaci\'on (inicialmente a cero). Cuando se termina de recorrer
% la lista (la lista es vac\'{\i}a), S se enlaza con el valor del
% par\'ametro de acumulaci\'on.
suma2([], A, A).
suma2([N|Resto], A, S) :- NewA is N + A, suma2(Resto, NewA, S).


/*************************************************
Medir el speedup del programa “suma2” con respecto al programa “suma1”.
*************************************************/


/*************************************************
Ejercicio 21.
La sucesión de Fibonacci está compuesta por los números:  a1=1, a2=1, a3=2, a4=3, a5=5, a6=8, ... Esta sucesión puede  definirse por intensión en los siguientes términos

a1=1;
a2=1;
an = an-1 + an-2 si n>2.

La anterior definición puede trasladarse a sintaxis Prolog de forma inmediata
*************************************************/

	fib(1,1).
	fib(2,1).
	fib(N,F) :- N>2, H1 is N-1, H2 is N-2,
		      fib(H1,F1),fib(H2,F2),
		      F is F1+F2.

/*************************************************
Sin embargo, este programa es muy ineficiente, pues tiende a rehacer muchos cálculos previamente efectuados. Podemos confirmar lo anterior sin más que inspeccionar la traza del objetivo "?- fib(6, F).", por ejemplo, puede verse que el número fib(3, _ ) se calcula en tres ocasiones. Utilizando una función auxiliar con parámetros de acumulación, definir un predicado fib2(N, F) que compute eficientemente el N-esimo número de Fibonacci evitando cómputos redundantes. Medir el speedup del programa “fib2” con respecto al programa “fib”.
*************************************************/

/* Para evitar computos redundantes empleamos un parmetro de acumulacin.
El tercer argumento de fib2 almacena el valor a_{N-1}. El valor de a_{N-1} debe calcularse
previamente, antes de calcular a_N. As mismo, para calculara_{N-1} el valor de a_{N-2} debe
calcularse previamente, etc. Cuando llegamos al final de la recursin, sabemos por definicin
que a_2=1 y a_1=1. A partir de ah los valores de los a_{N-1} se irn recuperando del parmetro
deacumulacin sin tener que calcularlos de nuevo.*/

fib2(N,F):- fib2(N,F,A).
fib2(0, 0, 0) :- !.
fib2(1, 1, 1) :- !.
fib2(2, 1, 1) :- !.
fib2(N, F, Fn_1) :- N1 is N - 1, fib2(N1, Fn_1, Fn_2), F is Fn_1 + Fn_2.

/*Se ha empleado el corte para evitar backtrackings innecesarios. Otra
solucin es poner la condicin (N > 2) en la segunda clusula.

UN PROBLEMA CON LA ANTERIOR SOLUCION ES QUE NO PERMITE LA RECURSION DE COLA. La siguiente soluci�n elimina ese problema. Al no tener que hacer uso de una pila resulta bastante m�s eficiente que la �ltima de las soluciones.*/

/******************************************************************
Una solución dada por IVAN BRATKO (Supone que N es un natural mayor que 0. Para N=0 calcula un resultado err�neo.)
fib3(N, F) :- forwardfib(2, N, 1, 1, F).
forwardfib(M, N, _, F2, F2) :- M >= N.
forwardfib(M, N, F1, F2, F) :-
	M < N, NextM is M + 1, NextF2 is F1 + F2,
	forwardfib(NextM, N, F2, NextF2, F).
*******************************************************************/
