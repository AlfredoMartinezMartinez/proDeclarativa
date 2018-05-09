%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     LABORATORIO 7 (Manipulación de términos y orden superior)     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**************************
Ejercicio 27.
Definir un predicado, ficha(H), que actuando sobre un hecho almacenado en una base de datos lo visualice en forma de ficha. Por ejemplo, si se lanzase el objetivo

  ?- ficha(libro(tol85,
			autor('Tolkien', 'J.R.R.' ),
			titulo('El Señor de los Anillos'),
			editorial(minotauro),
			prestado(jul101, fecha(28, noviembre, 2004)))).

se mostraría:

	libro:
		tol85,
		* autor:
			Tolkien,
			J.R.R.,
		* titulo:
			El Señor de los Anillos,
		* editorial:
			minotauro,
		* prestado:
			jul101,
			** fecha:
				28,
				noviembre,
				2004

[Observación: Escriba 8 caracteres para el sangrado de cada elemento.]
**************************/
% Hecho.
libro(tol85,
		autor('Tolkien', 'J.R.R.' ),
		titulo('El Se�or de los Anillos'),
		editorial(minotauro),
		prestado(jul101, fecha(28, noviembre, 2004))
      ).


ficha(H) :- dar_formato(H, 0).

/* El argumento Tabs indica el numero de tabs que hay que sangrar. Esta
relacion comprueba el tiopo de functor con el que se trabaja. Si es un
functor 0-ario (una constante) se escribe sin mas, seguido de ','. Si es
de aridad mayor que 0 se escribe el functor seguido de ':' y se manda
procesar cada uno de los argumentos.*/
dar_formato(T, Tabs_in) :-
	Tabs_out is Tabs_in +1,
	T =..[Functor|Argumentos],
	(Argumentos = [], !, tabs(Tabs_out), write(Functor), write(','), write('\n')
	;
	tabs(Tabs_out), write(Functor), write(':'), write('\n')),
	dar_formato_args(Argumentos, Tabs_out).

/* recorre los argumentos de un termino dandoles formato */
dar_formato_args([], _).
dar_formato_args([Arg|Argumentos], Tabs_in) :-
	dar_formato(Arg, Tabs_in),
	dar_formato_args(Argumentos, Tabs_in).

/* tabs(N), escribe N tabs */
tabs(0) :- !.
tabs(N) :- write('\t'), N1 is N -1, tabs(N1).





/**************************
Ejercicio 28.
a) Defina un predicado unific_a(X,Y) que tenga éxito cuando las expresiones
X e Y puedan ser unificadas. Esto es, queremos que se comporte como el predicado predefinido en Prolog para la unificación de expresiones.
**************************/


% Descomposicion de terminos
unific_a(T1,T2) :- compound(T1), compound(T2), !,
                  functor(T1, F1, Aridad1),
                  functor(T2, F2, Aridad2),
                  F1 == F2, Aridad1 =:= Aridad2,
                  T1 =.. [F1| ArgsT1],
                  T2 =.. [F1| ArgsT2],
                  unificaArgs_a(ArgsT1, ArgsT2).

unific_a(C1, C2) :- atomic(C1), atomic(C2), !, C1 == C2.

% Intercambio
unific_a(T,X) :- nonvar(T), var(X), !, unific_a(X,T).

% Eliminacion de variables
% Sin occur-check
unific_a(X,T) :- var(X), X = T.


%%%%%%%%
% unificaArgs(ArgsT1, ArgsT2)
% Comprueba si los terminos (argumentos) de las listas ArgsT1 y
% ArgsT2 son susceptibles de unificar uno a uno.

unificaArgs_a([], []).
unificaArgs_a([T1|Args1], [T2|Args2]) :- unific_a(T1,T2),
                  unificaArgs_a(Args1, Args2).




/**************************
b) Amplíe el programa anterior para que el predicado unific_a/2 compruebe la ocurrencia de variables. Denomine al nuevo predicado unific_b(X,Y).
**************************/

% Descomposicion de terminos
unific_b(T1,T2) :- compound(T1), compound(T2), !,
                  functor(T1, F1, Aridad1),
                  functor(T2, F2, Aridad2),
                  F1 == F2, Aridad1 =:= Aridad2,
                  T1 =.. [F1| ArgsT1],
                  T2 =.. [F1| ArgsT2],
                  unificaArgs_b(ArgsT1, ArgsT2).

unific_b(C1, C2) :- atomic(C1), atomic(C2), !, C1 == C2.

% Intercambio
unific_b(T,X) :- nonvar(T), var(X), !, unific_b(X,T).

% Eliminacion de variables
% Con occur-check
unific_b(X,T) :- var(X),
                (not(ocurre(X, T)), !, X = T;
                                     (write('la variable '),
                                     write(X),
                                     write(' ocurre en '),
                                     write(T),
                                     fail)).



%%%%%%%%
% unificaArgs(ArgsT1, ArgsT2)
% Comprueba si los terminos (argumentos) de las listas ArgsT1 y
% ArgsT2 son susceptibles de unificar uno a uno.

unificaArgs_b([], []).
unificaArgs_b([T1|Args1], [T2|Args2]) :- unific_b(T1,T2),
                  unificaArgs_b(Args1, Args2).

%%%%%%
% ocurre(X, T): verdadero si X ocurre en T.

ocurre(X, T) :- term_variables(T, VarsT),
                esta(X, VarsT).

/****************************************
Predicado predefinido:
term_variables(+Term, -List)
    Unify  List with  a list of  variables, each  sharing with a  unique
    variable of Term.  See also term_variables/3.  For example:

    ?- term_variables(a(X, b(Y, X), Z), L).

    L = [G367, G366, G371]
    X = G367
    Y = G366
    Z = G371
********************************************/

esta(X, [Y|_]) :- X==Y.
esta(X, [Y|R]) :- X\==Y, esta(X, R).



/**************************
Ejercicio 29.
a) Defina un predicado reduce(List,Func,Base,Result) que tenga éxito cuando las expresiones. El objeto del predicado reduce, que toma como argumentos de entrada, por ejemplo, una lista [e1, e2, e3], una función f (de aridad 2) y un valor inicial (base) b, es producir como resultado el valor f(e1, f(e2, f(e3, b))).
**************************/
%% reduce(Lista, Funcion, ValorBase, Resultado)
%% reduce(L, F, B, V)
%% si L = [e1,e2,e3] entonces V= F(e1, F(e2, F(e3, B)))

reduce([], _, B, B).
reduce([X|R], F, B, V):- reduce(R, F, B, V1), mi_apply(F,X,V1, V).

mi_apply(F,X,V1, V) :- T =.. [F, X, V1, V], T.


/**************************
b) Haciendo uso del predicado reduce/4 y de la función sum(X,Y), que suma los números X e Y, definir el predicado sumList(List, Suma) que suma los elementos de una lista de números.
**************************/

sumList(L,S):- reduce(L, sum, 0, S).

sum(X,Y,S):- S is X + Y.


/**************************
c) Haciendo uso del predicado reduce/4 y de la función mult(X,Y), que multiplica los números X e Y, definir el predicado multList(List, Prod) que multiplica los elementos de una lista de números.
**************************/

multList(L,P):- reduce(L, mult, 1, P).

mult(X,Y,S):- S is X * Y.
