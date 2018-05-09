%alternativa 1
f1(X,0) :- X<3.
f1(X,2) :- X>= 3, X<6.
f1(X,4) :- X>=6.

% ALternativa 2
f2(X,0) :- X < 3,!.
f2(X,2) :- X >= 3, X < 6,!.
f2(X,4) :- X >= 6.

pais('Alemania').
pais('España').
pais('Iralia').
pais('Francia').
pais('Egipto').
paises:- pais(P),write(P),nl,fail.
paises.
