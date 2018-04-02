%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          LISTAS                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ejercicio 4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% sus(X,Y,L1,L2),
%%% Sustituir el elemento X por Y en la lista L1, para dar L2.
sus(_,_,[],[]).
sus(X,Y,[Z|T],[Y|S]):-X=Z,sus(X,Y,T,S).
sus(X,Y,[Z|T],[Z|S]):-X\=Z,sus(X,Y,T,S).

%%% sus2(X,Y,L1,L2),
%%% Idem. usando el corte
sus2(_,_,[],[]).
sus2(X,Y,[X|T],[Y|S]):-!,sus2(X,Y,T,S).
sus2(X,Y,[Z|T],[Z|S]):-sus2(X,Y,T,S).

%%% sus3(X,Y,L1,L2),
%%% El comportamiento de sus3 difiere de sus y sus2
%%% para "?- sus(X,b,[a,b,c,a,b,c],L).". El comportamiento
%%% es identico cuando los argumentos estan instanciados.
sus3(_,_,[],[]).
sus3(X,Y,[Z|T],[Y|S]):-X==Z,sus3(X,Y,T,S).
sus3(X,Y,[Z|T],[Z|S]):-X\==Z,sus3(X,Y,T,S).

%%% sus4(X,Y,L1,L2) No es una implementaci�n correcta del problema
%%% Produce contestaciones que no son una respuesta (como producto de
%%% haber eliminado el corte de forma directa o indirecta
%%% NO ES POSIBLE LA INVERSIBILIDAD
sus4(_,_,[],[]).
sus4(X,Y,[Z|T],[Y|S]):-X=Z,sus4(X,Y,T,S).
sus4(X,Y,[Z|T],[Z|S]):-sus4(X,Y,T,S).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ejercicio 5.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Aplanar una lista: Definir la relación aplanar(Lista, Aplanada),
donde Lista es en general una lista de listas, tan compleja en su
anidamiento como queramos imaginar, y Aplanada es la lista que resulta
de reorganizar los elementos contenidos en las listas anidadas en un
único nivel. Por ejemplo:
	?- aplanar([[a, b], [c, [d, e]], f], L).
	L = [a, b, c, d, e, f]                              */

aplanar([], []).
aplanar([X|Resto], Resultado) :-
	atomic(X), aplanar(Resto, Res_Resto), Resultado = [X|Res_Resto].
aplanar([X|Resto], Resultado) :-
	not(atomic(X)), aplanar(X, Res_X), aplanar(Resto, Res_Resto), append(Res_X, Res_Resto, Resultado).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ejercicio 6.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% igualesElem(L1,L2) comprueba que L1 y L2 son listas con iguales elementos
%%% en cualquier orden.

igualesElem(L1,L2):- length(L1,N), length(L2,N), ie(L1,L2).
ie([],[]).
ie([X|Xs],[X|Ys]):- !, ie(Xs,Ys).
ie([X|Xs],[Y|Ys]):- eliminar(X,Ys,YYs), eliminar(Y,Xs,XXs), ie(XXs,YYs).

%%% Elimina un elemento X si, en efecto, aparece en la lista.
%%% Elimina el primer elemento que encuentra y corta la computaci�n.
eliminar(_,[],[]).
eliminar(X,[X|Ys],Ys):- !.
eliminar(X,[Y|Ys],[Y|Zs]):- eliminar(X,Ys,Zs).

%%%%%%%%%%
g_ie(L1,L2,T):- T1 is cputime, igualesElem(L1,L2),  T2 is cputime, T is T2-T1.

g(T) :- construirL1(13,L1), construirL2(13,L2), g_ie(L1, L2, T).
%% es capaz de comparar listas con (2^13)*66=540672 elementos como mucho

construirL1(L) :-
L1=[a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k],
L2=[f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e],
append(L1,L2,L).

construirL2(L) :-
L1=[a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k],
L2=[f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e,f,g,h,i,j,k,a,b,c,d,e],
append(L2,L1,L).

construirL1(N,L):- construirL1(LL), construir(N,LL,L).
construirL2(N,L):- construirL2(LL), construir(N,LL,L).
construir(0,L,L).
construir(N, A, L) :- NN is N-1, append(A,A,AA), construir(NN, AA, L).



e310([],[]).
e310([H|T],L):- append(L1,[H|L2],L),
	        append(L1,L2,L3),e310(T,L3).

g_ie310(L1,L2,T):- T1 is cputime, e310(L1,L2),  T2 is cputime, T is T2-T1.

g2(T) :- construirL1(9,L1), construirL2(9,L2), g_ie310(L1, L2, T).

%% es capaz de comparar listas con (2^9)*66=33792 elementos como mucho



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                        ARITMETICA                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ejercicio 7.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/***********************************
Problema: Descomponer un número en la suma de dos pares

Entrada: un natural N

Solución: dos naturales A y B tales que:
A es par,
B es par,
N = A + B
************************************/

descomponer(N,A,B) :-
	between(0,N,A), A mod 2 =:= 0,
	between(0,N,B), B mod 2 =:= 0,
	N =:= A + B.

%% Mejora a "descomponer" porque si conozco A puedo calcular B mediante un c�lculo.
%% Reduzco el indeterminismo de usar between(0,N,B)
descomponer2(N,A,B) :- between(0,N,A), A mod 2 =:= 0, B is N - A, B mod 2 =:= 0.

%% Mejora a "descomponer2" porque solamente un num. par puede descomponerse en pares.
%% Adem�s, al generar los n�meros A entre 0 y NN elimino las soluciones sim�tricas.
descomponer3(N,A,B) :- N mod 2 =:= 0, NN is N // 2,
		       between(0,NN,A), A mod 2 =:= 0, B is N - A, B mod 2 =:= 0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ejercicio 8.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
8) Rompecabezas de Brandreth.
El cuadrado de 45 es 2025. Notad que si
partimos el numero en dos obtenemos los
números 20 y 25 cuya suma es,
precisamente, 45. Obtener que otros números cuyo
cuadrado es un número
de cuatro cifras cumplen esta propiedad.
(Ayuda: los números N cuyo cuadrado
es de cuatro cifras pueden generarse mediante
una llamada al predicado
between(32, 99, N)). */

numBrandreth(N, C) :- between(32, 99, N), C is N * N,
		N1 is C // 100, N2 is C mod 100,
		N is N1 + N2.


/* Numeros de Brandreth cuyo cuadrado tiene seis cifras */
numBrandreth2(N, C) :- between(317, 999, N), C is N * N,
		N1 is C // 1000, N2 is C mod 1000,
		N is N1 + N2.
