% Ejercicio 27.
% Definir un predicado, ficha(H), que actuando sobre un hecho
% almacenado en una base de datos lo visualice en forma de
% ficha. Por ejemplo, si se lanzase el objetivo

% Ejercicio 28.
%  a) Defina un predicado unific_a(X,Y)que tenga éxito cuando las expresiones
% Xe Y puedan ser unificadas.
%  Esto es, queremos que se comporte como el predicado predefinido en Prolog para la unificación de expresiones.
%  b) Amplíe el programa anterior para que el predicado unific_a/2 compruebe la ocurrencia de variables.
%  Denomine al nuevo predicado unific_b(X,Y

%1. Descomposicion de terminos
unifica(T1,T2) :- compound(T1),compound(T2),
                  functor(F1,T1,N1), functor(F2,T2,N2),
                  F1 == F2, N1 =:= N2,
                  T1 =..[F1|Args1], T2=..[F2|Args2],
                  unifica_Args(Args1,Args2).



% Ejercicio 29. a) Defina un predicado reduce(List,Func,Base,Result)
