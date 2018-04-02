%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          ARBOLES                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Ejercicio 15.
Las rosadelfas se han representado en Prolog mediante los constructores:
1.nil;
2.hoja(X), donde X elemento de tipo T;
3.nodo(X, [T_1, ..., T_M]),  donde X es un elemento de tipo T, T_i es un árbol $n$--ario de tipo T, y M =< N.
El predicado esRosadelfa(O) permite determinar si un objeto O es o no una rosadelfa.

% esRosadelfa(O), el objeto O es una rosadelfa.
esRosadelfa(nil).
esRosadelfa(hoja(_)).
esRosadelfa(nodo(_, Rosadelfas)) :-  esListaRosadelfas(Rosadelfas).

esListaRosadelfas([R]) :- esRosadelfa(R).
esListaRosadelfas([R|Rosadelfas]) :- esRosadelfa(R), esListaRosadelfas(Rosadelfas).

Sin embargo, en la definición anterior no se hace ninguna comprobación del tipo de los elementos o sobre el número de hijos (o grado) de cada nodo. Modificar  el predicado anterior y definir un predicado esRosadelfa(O, N) que determine si un objeto O es una rosadelfa de grado N y realice las comprobaciones de tipo oportunas.
************************************************************/

% esRosadelfa(O, N), el objeto O es una rosadelfa de grado N, cuyos elementos
% son de un tipo definido.
esRosadelfa(nil, _).
esRosadelfa(hoja(X), N):- tipo(X).
esRosadelfa(nodo(X, Rosadelfas), N) :-
			tipo(X),
			length(Rosadelfas,M), M =< N,
			esListaRosadelfas(Rosadelfas, N).

esListaRosadelfas([R], N) :- esRosadelfa(R, N).
esListaRosadelfas([R|Rosadelfas], N) :- esRosadelfa(R,N), esListaRosadelfas(Rosadelfas, N).

tipo(X) :- integer(X).



/* Ejercicio 16.
Defina los siguientes predicados acerca de los árboles n–arios:
************************************************************/

%%%%%%%
% Por simplicidad no realizaremos chequeos de tipos y supondremos
% que trabajamos con arboles $N$--arios de tipo T arbitrarios
% (esto es, desde el punto de vista practico, suponemos que
% la lista contiene un numero $N$ indeterminado de subarboles)
%


/* a) peso(A, P) que calcule el peso P de un árbol n–ario A, entendiendo por “peso” el número de nodos que contiene dicho árbol.
************************************************************/
peso(nil, 0).
peso(hoja(_), 1).
peso(nodo(X, L), N) :- pesoSubarboles(L, M), N is M +1.

% pesoSubarboles(L, M), M es la suma de los pesos de los arboles que
% 			componen la lista L.
pesoSubarboles([], 0).
pesoSubarboles([A|L], M) :- peso(A, M1), pesoSubarboles(L, M2), M is M1 + M2.


/* b) grado(A, G) que calcule el grado G de un árbol n–ario A;  el “grado” de un nodo es el número de hijos de ese nodo y el “grado” de un árbol es el grado máximo de los nodos que lo componen.
************************************************************/

%%% grado(A, G)
grado(nil, 0).
grado(hoja(_), 0).
grado(nodo(X, L), G):- length(L,N1), gMaxRosadelfas(L,N2),
			  (N1 > N2 -> G=N1 ; G=N2).

%%% gMaxRosadelfas(L,M), M es el grado máximo de la lista de Rosadelfas L
gMaxRosadelfas(L,M) :- gMaxRosadelfas(L,0,M).
gMaxRosadelfas([],A,A).
gMaxRosadelfas([X|T],A,M):-
		grado(X,Gx),
		(Gx > A -> gMaxRosadelfas(T,Gx,M);
			   gMaxRosadelfas(T,A,M)).


% grado(nodo(1, [hoja(2), nodo(3, [hoja(4), hoja(5), hoja(6)])]),G).


/* c) frontera(A, F) que permite determinar la frontera F del árbol n–ario A. La frontera
de un árbol es la lista de sus hojas.
************************************************************/
frontera(nil, []).
frontera(hoja(X), [X]).
frontera(nodo(X, L), FL) :- fronteraSubarboles(L, FL).

fronteraSubarboles([], []).
fronteraSubarboles([A|L], F) :- frontera(A, L1), fronteraSubarboles(L, L2), append(L1, L2, F).


/* d) preorden(A, L) que permita recorrer los nodos del árbol n–ario A en orden preorden, obteniendo la lista L de nodos visitados y en el orden que fueron visitados. Un recorrido preorden consiste en visitar primero la raíz y después los subárboles de izquierda a derecha.
************************************************************/
preorden(nil, []).
preorden(hoja(X), [X]).
preorden(nodo(X, L), [X|RL]) :- recorridoSubarboles(L, RL).

recorridoSubarboles([], []).
recorridoSubarboles([A|L], RL) :- preorden(A, L1), recorridoSubarboles(L, L2), append(L1, L2, RL).



/* Ejercicio 17.
El predicado construirRosadelfa(L, G, R) construye una rosadelfa R, de grado G a partir de
los elementos de una lista L.
*/

% construirRosadelfa(L, G, A), construye una rosadelfa R, a partir
% de los elementos de una lista L.
construirRosadelfa([], _, nil).
construirRosadelfa([X], _, hoja(X)).
construirRosadelfa([X|L], G, nodo(X, Rosadelfas)):-
        partir(L, G, GListas),
        construirRosadelfas(GListas, G, Rosadelfas).


% construirRosadelfas(GListas, G, Rosadelfas)
construirRosadelfas([], _, []).
construirRosadelfas([L|GListas], G, [R|Rosadelfas]) :-
	construirRosadelfa(L, G, R), construirRosadelfas(GListas, G, Rosadelfas).


% partir(L, G, [L1|GListas]), divide la lista L en G partes iguales (salvo restos)
% La secuencia se devuelve en el segundo argumento, como una lista de
% listas.
/* INTUITIVAMENTE, partir opera calculando en C1 el tama�o de las partes, siempre
puede haber alg�n resto R1. Si hay un resto se distribuye uno a uno entre las listas.
------------------------------------------------------------------------------*/

partir(L, G, LL) :-
		length(L,N),
		(N < G -> listificar(L, LL);
			    C is N // G,
			    R is N mod G,
			    dividir(L,C,R,LL)
        ).

%% listificar(L,LL), transforma la lista L en una lista de listas de un elemento de L.
listificar([],[]).
listificar([X|T], [[X]|TT]) :- listificar(T,TT).


%% extraer(L, P1, L1, T1), extrae un prefijo, L1, de longitud P1, en la lista L.
%% También extrae la cola T1 de la lista L.
extraer(L, P1, L1, T1) :-
		length(L1, P1),
		append(L1, T1, L).

%% dividir(L, C, R, LL) divide una lista L en partes de longitud C ( si el resto R = 0)
%% o en partes de longitud C+1 (mientras R > 0)

dividir([], _, _, []).
dividir([X|Xs], C, 0, [L1|TT]) :-
        extraer([X|Xs], C, L1, T1),
        dividir(T1, C, 0, TT).
dividir([X|Xs], C, R, [L1|TT]) :-
                RR is R - 1,
                CC is C + 1,
                extraer([X|Xs], CC, L1, T1),
                dividir(T1, C, RR, TT).


/*****************
%%%% OBJETIVOS


% Ejercicio 15
%%%%%%%%%%%%%%

rosas :-
R1 =  nodo(23, [nodo(12, [nodo(4, [hoja(7)])]), nodo(22, [hoja(1), nil])]),
(esRosadelfa(R1, 2)
 -> write('R1 es una rosadelfa de grado 2. '), nl;
    write('R1 no es una rosadelfa de grado 2. '), nl
),
R2 = nodo(26, [nodo(15, [nodo(7, [nodo(10, [hoja(25), nil, hoja(3)])])]), hoja(4)]),
(esRosadelfa(R2, 3)
 -> write('R2 es una rosadelfa de grado 3. '), nl;
    write('R2 no es una rosadelfa de grado 3. '), nl
),
R3 = nodo(5, [nodo(6, [hoja(3)]), nodo(2,[hoja(1)]), nodo(0,[hoja(23)]), nodo(34,[hoja(56)])]),
(esRosadelfa(R3, 4)
 -> write('R3 es una rosadelfa de grado 4. '), nl;
    write('R3 no es una rosadelfa de grado 4. '), nl
),
R = nodo(9, [R1, R2, R3]),
(esRosadelfa(R, 4)
 -> write('R es una rosadelfa de grado 4. '), nl;
    write('R no es una rosadelfa de grado 4. '), nl
).


rosas(R1,R2,R3,R) :-
R1 =  nodo(23, [nodo(12, [nodo(4, [hoja(7)])]), nodo(22, [hoja(1), nil])]),
R2 = nodo(26, [nodo(15, [nodo(7, [nodo(10, [hoja(25), nil, hoja(3)])])]), hoja(4)]),
R3 = nodo(5, [nodo(6, [hoja(3)]), nodo(2,[hoja(1)]), nodo(0,[hoja(23)]), nodo(34,[hoja(56)])]),
R = nodo(9, [R1, R2, R3]).


% Ejercicio 16
%%%%%%%%%%%%%%

peso(PR1, PR2, PR3, PR) :- rosas(R1,R2,R3,R),
			   peso(R1, PR1),
			   peso(R2, PR2),
			   peso(R3, PR3),
			   peso(R, PR).

grado(GR1, GR2, GR3, GR) :- rosas(R1,R2,R3,R),
			   grado(R1, GR1),
			   grado(R2, GR2),
			   grado(R3, GR3),
			   grado(R, GR).

frontera(FR1, FR2, FR3, FR) :- rosas(R1,R2,R3,R),
			   frontera(R1, FR1),
			   frontera(R2, FR2),
			   frontera(R3, FR3),
			   frontera(R, FR).

preorden(PO_R1, PO_R2, PO_R3, PO_R) :- rosas(R1,R2,R3,R),
			   preorden(R1, PO_R1),
			   preorden(R2, PO_R2),
			   preorden(R3, PO_R3),
			   preorden(R, PO_R).

**************************************************************************/
