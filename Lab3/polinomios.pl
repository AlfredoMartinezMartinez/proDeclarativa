
%Ejercicio 12 dado un polinomio dar su resultado
%esPolinomio(P): verdadero si P es esPolinomio
% P es polinomio sii:
% P==P1+S si p1 es polinomio y s es sumando monomio
% P==P1-S si P1 es polinomio y S es un sumando(monomio)
% un sumando S es un monomio.S es un monomio sii:
% S==C si C es entero
% S== C*F si C es un entero y F es un funcion potencia
% F es una potencia sii:
% F==x
% F== x**E si E es un entero


esPolinomio(P+Q):- esPolinomio(P),esPolinomio(Q).
esPolinomio(P-Q):- esPolinomio(P),esPolinomio(Q).
esPolinomio(C):- integer(C).
%x es constante, no es variable esPolinomio de primer grado
esPolinomio(x).
esPolinomio(C*x):- integer(C).
esPolinomio(C*x**N) :- integer(C), integer(N).

% eval(P,V,R) :- X = V, R is P.
% eval(P,V,R) :R es el resultado de evaluar el polimonio P cuando x=V
%evaluacion de polinomio
eval(P+Q,V,R) :- eval(P,V,RP),eval(Q,V,RQ),R is RP + RQ.
%en la ss ins se podria poner R=C pero es mas legal para prolog hacer unifica
%cion al principio
% eval(C,V,R):- integer(C),R=C
eval(C,V,C):- integer(C).
eval(x,V,V).
eval(C*x,V,R):- integer(C),R is C*V.
eval(C*x**N,V,R):- integer(C),integer(N),R is C*V**N.
