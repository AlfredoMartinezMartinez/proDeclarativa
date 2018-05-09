%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     ESTRUCTURAS DE CONTROL Y ENTRADA/SALIDA                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*************************************************
Ejercicio 22.
*************************************************/
p(X) :- q,r(X).
p(X) :- s(X),t.
q :- a,!b.
q :- c,d.
b :- fail.
r(uno).
s(dos).
a.
c.
t.
d.


/*************************************************
Ejercicio 23.
Definir un predicado add(X, L, L1) que añada un elemento X, a la lista L para dar L1, sin incurrir en repeticiones de elementos. Esto puede hacerse mediante la siguiente regla

	Si X es miembro de la lista L entonces L1 = L,
	si no L1 es igual a la lisa [X | L];

para cuya implementación es necesario el empleo del corte. Comprobar que omitiendo el corte o alguna construcción derivada del corte (e. g. el predicado not) sería posible la adición de elementos repetidos. Por ejemplo, llame a la nueva versión sin corte "add2" y compruebe que

		?- add2(a, [a, b, c], L).
		L = [a, b, c];
		L = [a,a, b, c]

Así pues, en la solución de este ejercicio es vital el empleo del corte para obtener el significado esperado para nuestro predicado y no como un mero instrumento para aumentar la eficiencia.
*************************************************/
% version que cumple la especificación.
add(X,L,L) :- member(X,L), !.
add(X,L,[X|L]).

% version que NO cumple la especificación.
add2(X,L,L) :- member(X,L).
add2(X,L,[X|L]).


/*************************************************
Ejercicio 24.
Queremos definir un predicado diferente(X, Y) que sea verdadero cuando X e Y no unifican. Esto puede decirse en PROLOG  teniendo en cuenta que

	Si X e Y unifican entonces diferente(X, Y) falla,
	si no diferente(X, Y) tiene éxito.

Definir este predicado empleando a) el corte, fail y true (llame a esta versión "diferente_a"); b) empleando únicamente not (llame a esta versión "diferente_b").
*************************************************/

diferente_a(X, Y) :- X = Y, !, fail ; true.

diferente_b(X, Y) :- not(X =Y).


/*************************************************
Ejercicio 25.
El predicado predefinido repeat no es imprescindible en la programación con el lenguaje PROLOG. a) Para confirmar el anterior aserto, escribe un pequeño programa llamado cubo que solicite un número por teclado y calcule su cubo. El programa debe operar como a continuación se indica

			?- cubo.
			Siguiente número 5.
			El cubo de 5 es 125
 			Siguiente número 3.
			El cubo de 5 es 27
			Siguiente número stop.
			yes

b) Dar una versión empleando repeat.
*************************************************/

% version 1.
cubo :- write('Siguiente numero: '),
        read(X),
	(X = stop, !, true;
	  (elevar(X),
	   cubo
	  )
	).


% version 2.
cubo2 :-
	repeat,
	write('Introducir entrada : '),
	read(X),
	( X = stop, !
	  ;
	  elevar(X),
	  fail
	).

elevar(N) :- Cubo_N is N**3,
	write(' El cubo de '), write(N), write(' es '), write(Cubo_N), nl.


/******************** ELIMINADO
Ejercicio 26.
Definir un predicado “echo” que lea una línea de texto y la escriba por pantalla.
*************************************************/



/*************************************************
Ejercicio 26.
Definir un predicado “cont(File)” que tome como argumento el nombre de un fichero de texto y cuente los caracteres, las palabras y las lineas contenidas en ese fichero, procurando dar un formato agradable a la salida por pantalla.
*************************************************/

cont(FileName, Cont_carac, Cont_palab, Cont_lineas) :-
    (see(FileName), ! ,            			  % Abrir el fichero
    tratamiento(0, 0, 0, Cont_carac, Cont_palab, Cont_lineas)   % si todo va bien,
    ;
    seen, quit),                 			  % si no abortar
    seen,
    write('Numero de caracteres = '), write(Cont_carac), nl,
    write('Numero de palabras =   '), write(Cont_palab), nl,
    write('Numero de lineas =     '), write(Cont_lineas), nl.

%%% SEPARADORES
%%% [' ', '\t', '(', ')', ',', '.', ';', '�', '?'] ---> [32, 9, 40, 41, 44, 46, 59, 191, 63]
%%% '\n' == 10
tratamiento(Cont_c, Cont_p, Cont_l, Cont_carac, Cont_palab, Cont_lineas) :-
  get0(C),
  (% caso 1. fin de fichero
     C == -1, !,
	Cont_carac = Cont_c, Cont_palab = Cont_p, Cont_lineas = Cont_l;
  %  caso 2. caracteres a saltar antes/despues de una palabra
     member(C, [32, 40, 41, 44, 46, 59, 191, 63]), !,
  	CC is Cont_c + 1,
  	tratamiento(CC, Cont_p, Cont_l, Cont_carac, Cont_palab, Cont_lineas);
  % caso 3. fin de linea (fuera de una palabra)
    C = 10, !,
	CC is Cont_c + 1, CL is Cont_l + 1,
  	tratamiento(CC, Cont_p, CL, Cont_carac, Cont_palab, Cont_lineas);
  % otherwise dentro de una palabra
	palabra(1, Total, Delimitador),
	(Delimitador = -1, !, CC is (Total + Cont_c)
	                     ; CC is (Total + Cont_c + 1)), % Total palabra + Delimitador
	CP is Cont_p + 1,
	((Delimitador = 10;Delimitador = -1), !, CL is Cont_l + 1; CL = Cont_l),
	tratamiento(CC, CP, CL, Cont_carac, Cont_palab, Cont_lineas)
  ).



palabra(CC1, Total, Delimitador) :-
	get0(C), tot_palabra(C, CC1, Total, Delimitador).
tot_palabra(-1, CC1, CC1, -1) :-  !.   %% fin_fichero
tot_palabra(C, CC1, CC1, C) :-
	member(C, [10, 32, 40, 41, 44, 46, 59, 191, 63]), !.
tot_palabra(_, CC1, Total, Delimitador) :-
	CC2 is CC1 + 1,
	palabra(CC2,Total, Delimitador).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
