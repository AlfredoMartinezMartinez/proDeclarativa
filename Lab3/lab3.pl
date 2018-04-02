%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Más sobre listas, aritmética y computación simbólica          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Ejercicio 9.
Defina un predicado partir(L, L1, L2) que divida la lista L en dos partes L1 y L2, tales que los elementos de L1 son menores o iguales que un cierto elemento N perteneciente a L y los de L2 son mayores que ese elemento N. El elemento N seleccionado no se incluye en las listas partidas L1 y L2.
******************************************************************/

%% Sea L una lista de n\'umeros.
%% partir(L, L1, L2) divide la lista L en dos partes L1 y L2,
%% tales que los elementos de L1 son menores o iguales que un
%% cierto N en L y los de L2 son mayores que ese N. El elemento
%% N seleccionado, no se incluye en las listas partidas L1 y L2.

partir([], [], []).
partir([N|T], L1, L2):- filtrar(N, T, L1, L2).

%% filtrar es un predicado auxiliar. El valor N
%% podr\'ia haberse suministrado de forma m\'as
%% compleja, mediante un c\'alculo y no simplemente
%% tomando el primer elemento a partir

filtrar(_, [], [], []).
filtrar(N, [X|T], [X|L1], L2):- X =< N, filtrar(N, T, L1, L2).
filtrar(N, [X|T], L1, [X|L2]):- X > N, filtrar(N, T, L1, L2).



/*
Ejercicio 10.  (Ordenación rápida—quicksort—)
El algoritmo de ordenación rápida aplica la estrategia de “divide y vencerás” a la tarea de ordenar una lista. La idea es particionar una lista con respecto a uno de sus elementos (en principio elegido al azar), llamado el pivote, de forma que los elementos menores o iguales que el pivote queden agrupados a su izquierda, en una de las listas, y los elementos mayores que el pivote queden agrupados a su derecha, en la otra lista. Observe que, tras la partición, lo único seguro es que el pivote está en el lugar que le corresponderá en la ordenación final. Entonces, el algoritmo se centra en la ordenación de las porciones de la lista (que no están necesariamente ordenadas), lo que nos remite al problema original. Utilizando el predicado partir(L, L1, L2) del Ejercicio 9, dé una implementación recursiva del algoritmo de ordenación rápida.
******************************************************************/

quicksort([],[]).
quicksort([X|T], O):- partir([X|T],L1,L2),
                  quicksort(L1,O1),
                  quicksort(L2,O2),
                  append(O1, [X|O2], O).


/*
Ejercicio 11.  (Mezcla ordenada —merge–sort—)
Implemente en Prolog el algoritmo de mezcla ordenada para la ordenación de una lista de elementos. Informalmente, este algoritmo puede formularse como sigue: Dada una lista, divídase en dos mitades, ordene cada una de las mitades y, después, “mezcle”  apropiadamente las dos listas ordenadas obtenidas en el paso anterior.
******************************************************************/
% merge_sort(L, O), O es la lista que resulta de ordenar
%                   la lista L.
merge_sort([], []).
merge_sort([X], [X]).
merge_sort([X|L], O) :-
                partir2([X|L], LL, LR),
                merge_sort(LL, OL),
                merge_sort(LR, OR),
                merge(OL, OR, O).


% partir2(L, LL, LR), divide la lista L en dos partes
% iguales LL y LR (salvo restos).
partir2(L, LL, LR) :-
                length(L, N), M is (N // 2),
                length(LL, M), append(LL,LR,L).

% merge(OL, OR, O), mezcla los elementos de dos listas
% ordenadas, OL y OR, de forma que resulte una lista
% ordenada O.
merge([], OR, OR).
merge(OL, [], OL).
merge([X|OL], [Y|OR], [X|O]) :-
                X < Y, !, merge(OL, [Y|OR], O).
merge([X|OL], [Y|OR], [Y|O]) :-
                X >= Y, merge([X|OL], OR, O).


/*
Ejercicio 12.
El polinomio Cnxn + : : : + C2x2 + C1x + C0, donde Cn; ... ;C1;C0 son coeficientes enteros, puede representarse en Prolog mediante el siguiente término:
cn * x ** n + ... + c2 * x ** 2 + c1 * x + c0.
El operador “**” es un operador binario infijo. Cuando se evalúa la expresión “X ** n”, computa la potencia enésima de X. Observe que el operador “**” liga más que el operador binario infijo “*”, que a su vez liga más que el operador binario infijo “+” (por lo tanto no se requiere el uso de   paréntesis). Observe también que, en la representación anterior, la variable x se trata como una constante. Defina un predicado eval(P, V, R) que devuelva el resultado R de evaluar un polinomio P para un cierto valor V de la variable x. A modo de ejemplo, el objetivo ?- eval(5 * x ** 2 + 1, 4, R). debe tener éxito con respuesta R = 81.
******************************************************************/

% sol_exdfeb07
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2: define eval empleando recursion sobre
% patrones
%
%  P es un polinomio sii:
%	P == P1 + S       si P1 es un polinomio y
%                            S es un sumando (monomio);
%	P == P1 - S       si P1 es un polinomio y
%                            S es un sumando (monomio);
%
%  Un sumando S es un monomio. S es un monomio sii:
%	S == C            si C es un entero;
%	S == C * F        si C es un entero y
%                            F una funcion potencia;
%
%  F una funcion potencia sii:
%	F == x
%	F == x ** E       si E es un entero.

% Evalua un polinomio.
eval(P + S, V, R) :- eval(P, V, P1),
	eval(S, V, S1),
	R is P1 + S1, !.
eval(P - S, V, R) :- eval(P, V, P1),
	eval(S, V, S1),
	R is P1 - S1, !.

% Evalua un monomio.
eval(C * F, V, R) :- integer(C),
	eval(F, V, F1),
	R is C * F1, !.
eval(C, _, C) :- integer(C), !.

% Evalua una funcion potencia.
eval(x, V, V):- !.
eval(x ** E, V, R) :- integer(E),
	R is V ** E.


/*
Ejercicio 13.
Utilizando la representación de los polinomios propuesta en el ejercicio anterior, defina un predicado d(P, D) que compute la derivada D de un polinomio P con respecto a x. Se requiere que el polinomio D, que se obtiene como resultado, se presente en un formato simplificado. Esto es, si lanzamos el objetivo:
?- d(2 * x ** 2 + 3, D).
debe devolver la respuesta “D = 4 * x “ y no “D = 2* 2 * x + 0“.
******************************************************************/

d(P,D) :- deriv(P,D1), simp(D1,D).

% Derivada de un polinomio.
deriv(P + S, P1 + S1) :- deriv(P, P1), deriv(S, S1).
deriv(P - S, P1 - S1) :- deriv(P, P1), deriv(S, S1).

% Derivada de un monomio.
deriv(C, 0) :- integer(C).
deriv(x, 1).
deriv(x ** E, E * x ** E1) :- integer(E), E1 is E -1.
deriv(C * x, C) :- integer(C).
deriv(C * x ** E, C1 * x ** E1) :- integer(C), integer(E), C1 is C * E, E1 is E -1.


% Simplifica un polinomio.
simp(P + 0, P1) :- !, simp(P, P1).
simp(P - 0, P1) :- !, simp(P, P1).
simp(0 + P, P1) :- !, simp(P, P1).
simp(0 - P, P1) :- !, simp(P, P1).
simp(P + S, P1 + S1) :- simp(P, P1), simp(S, S1).
simp(P - S, P1 - S1) :- simp(P, P1), simp(S, S1).

% Simplifica un monomio.
simp(C, C) :- integer(C), !.
simp(x, x) :- !.
simp(x ** 1, x) :- !.
simp(x ** E, x ** E)  :- !.
simp(C * x ** 1, C * x) :- integer(C), !.
simp(C * x ** E, C * x  ** E) :- integer(C), integer(E).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
