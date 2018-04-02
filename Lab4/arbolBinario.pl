%frontera (A,F), F es la frontera del arbol binario A
nodo(N,Tl,Tr).
hoja(N).
frontera(nil,[]).
frontera(hoja(N),[N]).
frontera(nodo(N,Tl,Tr),F) :- frontera(Tl,L),frontera(Tr,R),append(L,R,F).

% frontera(nodo(8,(nodo(5,hoja(3),hoja(6)),(nodo(10,hoja(4),hoja(5),F).
goal(F):-frontera(A,F).
