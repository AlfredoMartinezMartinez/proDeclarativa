% Ejercicio 9.
% Defina un predicado partir(L, L1, L2) que divida la lista L en dos partes L1 y L2, tales
% que los elementos de L1 son menores o iguales que un cierto elemento N
% perteneciente a L y los de L2 son mayores que ese elemento N. El elemento N
% seleccionado no se incluye en las listas partidas L1 y L2.
partir([],[],[]).
partir([N|T],L1,L2) :- filtrar(N,T,L1,L2).
%% filtrar es un predicado auxiliar. El valor N
%% podr\'ia haberse suministrado de forma m\'as
%% compleja, mediante un c\'alculo y no simplemente
%% tomando el primer elemento a partir
filtrar(_,[],[],[]).
filtrar(N,[X|T],[X|L1],L2) :- X =< N,filtrar(N,T,L1,L2).
filtrar(N,[X|T],L1,[X|L2]) :- X > N,filtrar(N,T,L1,L2).

% Ejercicio 10. (Ordenación rápida—quicksort—)
% El algoritmo de ordenación rápida aplica la estrategia de “divide y vencerás” a la
% tarea de ordenar una lista. La idea es particionar una lista con respecto a uno de sus
% elementos (en principio elegido al azar), llamado el pivote, de forma que los
% elementos menores o iguales que el pivote queden agrupados a su izquierda, en una
% de las listas, y los elementos mayores que el pivote queden agrupados a su derecha,
% en la otra lista. Observe que, tras la partición, lo único seguro es que el pivote está en
% el lugar que le corresponderá en la ordenación final. Entonces, el algoritmo se centra
% en la ordenación de las porciones de la lista (que no están necesariamente ordenadas),
% lo que nos remite al problema original. Utilizando el predicado partir(L, L1, L2) del
% Ejercicio 10, dé una implementación recursiva del algoritmo de ordenación rápida,
% mediante la definición de un predicado: quicksort(Lista, ListaOrdenada).
quicksort([],[]).
quicksort([X|T],O) :- partir([X|T],L1,L2),
                  quicksort(L1,O1),
                  quicksort(L2,O2),
                  append(O1,[X|O2],O).

% Ejercicio 11. (Mezcla ordenada —merge_sort—)
% de elementos, mediante la definición de un predicado: merge_sort(Lista,
% ListaOrdenada). Informalmente, este algoritmo puede formularse como sigue: Dada
% Implemente en Prolog el algoritmo de mezcla ordenada para la ordenación de una lista
% una lista, divídase en dos mitades, ordene cada una de las mitades y, después,
% “mezcle” apropiadamente las dos listas ordenadas obtenidas en el paso anterior.


% Ejercicio 12.
% El polinomio Cnx + : : : + C2x + C1x + C0, donde Cn; ... ;C1;C0 son coeficientes
% enteros, puede representarse en Prolog mediante el siguiente término:
% cn * x ** n + ... + c2 * x ** 2 + c1 * x + c0.
% El operador “**” es un operador binario infijo. Cuando se evalúa la expresión “X ** n”,
% computa la potencia enésima de X. Observe que el operador “**” liga más que el
% operador binario infijo “*”, que a su vez liga más que el operador binario infijo “+”
% (por lo tanto no se requiere el uso de paréntesis). Observe también que, en la
% representación anterior, la variable x se trata como una constante. Defina un
% predicado eval(P, V, R) que devuelva el resultado R de evaluar un polinomio P para un
% cierto valor V de la variable x. A modo de ejemplo, el objetivo ?- eval(5 * x ** 2 + 1, 4,
% R). debe tener éxito con respuesta R = 81.


% Ejercicio 13.
% Utilizando la representación de los polinomios propuesta en el ejercicio anterior,
% defina un predicado d(P, D) que compute la derivada D de un polinomio P con respecto
% a x. Se requiere que el polinomio D, que se obtiene como resultado, se presente en un
% formato simplificado. Esto es, si lanzamos el objetivo:
% ?- d(2 * x ** 2 + 3, D).
% debe devolver la respuesta “D = 4 * x “ y no “D = 2* 2 * x ** 1 + 0“.
