% Ejercicio 4.
% Definir un predicado sus(X,Y,L1,L2) que sea capaz de sustituir un elemento X por otro Y en la
% lista L1, para dar L2.

sus(_,_,[],[]).
sus(X,Y,[Z|T],[Y|S]):- X=Z,sus(X,Y,T,S).
sus(X,Y,[Z|T],[Z|S]):- X\=Z, sus(X,Y,T,S).

%%% sus3(X,Y,L1,L2),
%%% El comportamiento de sus3 difiere de sus y sus2
%%% para "?- sus(X,b,[a,b,c,a,b,c],L).". El comportamiento
%%% es identico cuando los argumentos estan instanciados.
sus3(_,_,[],[]).
sus3(X,Y,[Z|T],[Y|S]):-X==Z,sus3(X,Y,T,S).
sus3(X,Y,[Z|T],[Z|S]):-X\==Z,sus3(X,Y,T,S).

% Ejercicio 5.
% Definir la relación aplanar(Lista, Aplanada), donde Lista es en general una lista de listas, tan
% compleja en su anidamiento como queramos imaginar, y Aplanada es la lista que resulta de
% reorganizar los elementos contenidos en las listas anidadas en un único nivel, i.e. una lista plana.
% Por ejemplo
% ?- aplanar([[a, b], [c, [d, e]], f], L).
% L = [a, b, c, d, e, f]
aplanar([],[]).
aplanar([X|T],LPlana) :-
  atomic(X),aplanar(T,LPT),LPlana = [X|LPT].
aplanar([X|T],LPlana) :-
  not(atomic(X)),aplanar(X,LPX),aplanar(T,LPT),append(LPX,LPT,LPlana).

% aplanar([],[]).
% %aplanar([X|T],LPlana) :- atomic(X),aplanar(T|LPT),LPlana=[X|LPT].
% aplanar([X|T],[X|LPT]) :- atomic(X),aplanar(T|LPT).
% aplanar([X|T],LPlana) := not(atomic (X)) ,aplanar(X,LPX),aplanar(T,LPT),append(LPX,LPT,LPlana).

% Ejercicio 6.
% Definir un predicado igualesElem(L1,L2) que compruebe que L1 y L2 son listas que contienen los
% mismos elementos independientemente del orden de aparición.
% [Ayuda: utilizar el predicado length/2]
igualesElem(L1,L2) :- length(L1,N),length(L2,N),ie(L1,L2).
ie([],[]).




% Ejercicio 7.
% Definir un predicado descomponer(N,A,B) que permita resolver el problema de descomponer un
% número natural N en la suma de dos pares A y B. Esto es,descomponer(N,A,B) debe tomar como
% entrada un natural N y devolver dos naturales A y B tales que N = A + B.
% [Ayuda: utilizar el predicado between/3]
/***********************************
Problema: Descomponer un número en la suma de dos pares

Entrada: un natural N

Solución: dos naturales A y B tales que:
A es par,
B es par,
N = A + B
************************************/
descomponer(N,A,B) :- between(0,N,A),A mod 2 =:= 0,
                      between(0,N,B),B mod 2 =:= 0,
                      N =:= A + B.
%% Mejora a "descomponer" porque si conozco A puedo calcular B mediante un c�lculo.
%% Reduzco el indeterminismo de usar between(0,N,B)
descomponer2(N,A,B) :- between(0,N,A),A mod 2 =:=0,
                       B is N-A, B mod 2 =:=0.
%% Mejora a "descomponer2" porque solamente un num. par puede descomponerse en pares.
%% Adem�s, al generar los n�meros A entre 0 y NN elimino las soluciones sim�tricas.
descomponer3(N,A,B) :- N mod 2 =:= 0, NN is N // 2,
                       between(0,NN,A),A mod 2 =:=0,
                       B is N - A, B mod 2 =:=0.

% Ejercicio 8.
% Rompecabezas de Brandreth. El cuadrado de 45 es 2025. Notad que si partimos el número en dos
% obtenemos los números 20 y 25 cuya suma es, precisamente, 45. Obtener que otros números cuyo
% cuadrado es un número de cuatro cifras cumplen esta propiedad. Con este fin, definir un
% predicado numBrandreth (N, C) que devuelva uno de estos números N y su cuadrado C.
% [Ayuda: los números N cuyo cuadrado es de cuatro cifras pueden generarse mediante una llamada
% al predicado between(32, 99, N)].
numBrandreth(N,C) :- between(32,99,N), C is N*N,
                     N1 is C // 100, N2 is C mod 100,
                     N is N1+N2.
/* Numeros de Brandreth cuyo cuadrado tiene seis cifras */
numBrandreth2(N,C) :- between(317,999,N), C is N*N,
                    N1 is C //1000, N2 is C mod 1000,
                    N is N1+N2.

% Ejercicio extra
% ultimo elemento de una lista
% ultimo(U,L), U es el ultimo elemento de una lista L
ultimo(U,[U]).
ultimo(U,[_|R]) :-ultimo(U,R).
% otra manera con append
% ultimo(U,L) :- append(_,[U],L).

% esLista(L), L es una lista
esLista([]) .
esLista([_|R]):- esLista(R).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Operaciones con sublistas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prefijo(P,L),P es un prefijo de la lista L.
prefijo(P,L) :- esLista(L),append(P,_,L).
% sufijo(P,L), P es un sufijo de la lista L.
sufijo(P,L):- esLista(L),append(_,P,L).
% sublista(S,L), S es una sublista de la lista L.
subLista(S,L):- prefijo(S,L1),sufijo(L1,L).
% operaciones mas optimizadas eliminando comprobaciones
prefijo2(P,L) :- append(P,_,L).
sufijo2(P,L) :- append(_,P,L).
subLista2(S,L) :- append(S,_,L1),append(_,L1,L).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Invertir una lista
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% invertir(L,I), I es la lista que resulta de invertir L.
invertir([],[]).
invertir([H|T],L) :- invertir(T,Z), append(Z,[H],L).
timeinvertir(X,Y,T) :- T1 is cputime,invertir(X,Y),T2 is cputime,T is T2-T1.
% invertir usando parametros de acumulacion, mas eficiente
invertir2(L,I) :- inv(L,[],I).
% inv(Lista, Acumulador, Invertida)
inv([],I,I).
inv([X|R],A,I) :- inv(R,[X|A],I).
timeinv(X,Y,T) :- T1 is cputime,invertir2(X,Y),T2 is cputime,T is T2-T1.
