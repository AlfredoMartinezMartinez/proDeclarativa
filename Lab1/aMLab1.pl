%%% HECHOS
padre(teraj,abraham).
padre(teraj,najor).
padre(teraj,haran).
padre(teraj,sarai).
padre(abraham,isaac).
padre(abraham,ismael).
padre(haran,lot).
padre(haran,melca).
padre(haran,jesca).
padre(najor,batuel).
padre(najor,laban).
padre(batuel,rebeca).
padre(isaac,esau).
padre(isaac,jacob).

madre(agar,ismael).
madre(sarai,isaac).
madre(melca,batuel).
madre(rebeca,esau).
madre(rebeca,jacob).

hombre(isaac).
hombre(lot).
hombre(ismael).
hombre(teraj).
hombre(abraham).
hombre(najor).
hombre(haran).
hombre(batuel).
hombre(esau).
hombre(jacob).
hombre(laban).

mujer(melca).
mujer(jesca).
mujer(sarai).
mujer(agar).
mujer(rebeca).

casado(abraham,sarai).
casado(abraham,agar).
casado(najor,melca).
casado(isaac,rebeca).



%%% REGLAS
casados(X,Y) :- casado(X,Y);casado(Y,X).
ascendiente_directo(X, Y) :- (padre(X, Y); madre(X, Y)).
ascendiente(X, Z) :- ascendiente_directo(X, Z).
ascendiente(X, Z) :- ascendiente_directo(X, Y), ascendiente(Y, Z).

descendiente_directo(X,Y) :- (hijo(X,Y); hija(X,Y)).
descendiente(X,Z) :- descendiente_directo(X,Z).
descendiente(X,Z) :- descendiente_directo(X,Y), descendiente(Y,Z).

hijo(X,Y) :- hombre(X), ascendiente_directo(Y,X).
hija(X,Y) :- mujer(X), ascendiente_directo(Y,X).

abuelo(X,Z) :- padre(X,Y), ascendiente_directo(Y,Z).
abuela(X,Z) :- madre(X,Y), ascendiente_directo(Y,Z).

nieto(X,Z) :- hijo(X,Y), descendiente_directo(Y,Z).
nieta(X,Z) :- hija(X,Y), descendiente_directo(Y,Z).

hermano(X,Y) :- hombre(X), ascendiente_directo(Z,X),
                ascendiente_directo(Z,Y),X \== Y.
hermana(X,Y) :- mujer(X),ascendiente_directo(Z,Y),
                ascendiente_directo(Z, X),X \== Y.
hermanos(X,Y) :- (hermano(X,Y);hermana(X,Y)).

tio_carnal(X, Y) :- hombre(X), hermano(X, Z), ascendiente_directo(Z, Y), X \== Y.
tia_carnal(X, Y) :- mujer(X), hermana(X, Z), ascendiente_directo(Z, Y), X \== Y.
tio_no_carnal(X,Y) :- hombre(X), casados(X,Z), tia_carnal(Z,Y).
tia_no_carnal(X,Y) :- mujer(X), casados(X,Z), tio_carnal(Z,Y).

tio(X, Y) :- hombre(X),(tio_carnal(X,Y);tio_no_carnal(X,Y)).
tia(X, Y) :- mujer(X), (tia_carnal(X,Y);tia_no_carnal(X,Y)).

sobrino(X, Y) :- hombre(X),(tio(Y,X);tia(Y,X)).
sobrina(X, Y) :- mujer(X),(tio(Y,X);tia(Y,X)).

primo(X, Y) :- hombre(X),ascendiente_directo(Z1,X),ascendiente_directo(Z2,Y),
               hermanos(Z1,Z2).
prima(X, Y) :- mujer(X),ascendiente_directo(Z1,X),ascendiente_directo(Z2,Y),
               hermanos(Z1,Z2).
primos(X,Y) :- (primo(X,Y);prima(X,Y)).

incestuosos(X,Y) :- hombre(X),mujer(Y),casados(X,Y),(hermanos(X,Y);primos(X,Y);
                    padre(X,Y),hijo(X,Y);abuelo(X,Y);nieto(X,Y);tio(X,Y);sobrino(X,Y)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ejercicio 7. % 6 puntos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

familia( persona(antonio, foix, fecha(7, mayo, 1950), trabajo(renfe, 1800)),
	persona(maria, lopez, fecha(17, enero, 1952), trabajo(sus_labores, 0)),
	[ persona(patricia, foix, fecha(10, noviembre, 1970), trabajo(estudiante, 0)),
	  persona(juan, foix, fecha(30, agosto, 1972), trabajo(estudiante,0)) ] ).
familia( persona(manuel, monterde, fecha(15, marzo, 1934), trabajo(profesor, 2000)),
	persona(pilar, gonzalez, fecha(9, julio, 1940), trabajo(maestra, 1900)),
	[ persona(manolo, monterde, fecha(10, febrero, 1964), trabajo(arquitecto, 5000)),
	  persona(javier, monterde, fecha(24, noviembre, 1968), trabajo(estudiante, 0)) ] ).
familia( persona(jose, benitez, fecha(3, septiembre, 1958), trabajo(profesor, 2000)),
	persona(aurora, carvajal, fecha(29, agosto, 1972), trabajo(maestra, 1900)),
	[ persona(jorge, benitez, fecha(6, noviembre, 1997), trabajo(desocupado, 0))] ).
familia( persona(jacinto, gil, fecha(7, junio, 1958), trabajo(minero, 1850)),
	persona(guillermina, diaz, fecha(12, enero, 1957), trabajo(sus_labores, 0)),
	[ persona(carla, gil, fecha(1, agosto, 1958), trabajo(oficinista, 1500)),
	  persona(amalia, gil, fecha(6, abril, 1962), trabajo(deliniante, 1900)),
	  persona(irene, gil, fecha(3, mayo, 1970), trabajo(estudiante, 0)) ] ).
familia( persona(ismael, ortega, fecha(7, junio, 1966), trabajo(carpintero, 2350)),
	persona(salvadora, diaz, fecha(12, enero, 1968), trabajo(sus_labores, 0)),
	[] ).
familia( persona(pedro, ramirez, fecha(7, junio, 1966), trabajo(en_paro,0)),
	persona(teresa, fuentes, fecha(12, enero, 1968), trabajo(administrativa, 1250)),
	[] ).

ej2a(Nombre,Apellidos) :- nl, write('madre casada que tiene tres hijos o mas:'),nl,familia(_,persona(Nombre,Apellidos,_,_),[_,_,_ |_]).
eje2a(Nombre, Apellidos) :- familia(_, persona(Nombre, Apellidos, _, _), L), length(L, X), X>=3.

ej2b(Apellidos_Padre, Apellidos_Madre):- nl, write('Familias que no tienen hijos:'), nl,
familia(persona(_,Apellidos_Padre,_,_),persona(_,Apellidos_Madre,_,_),[]).

ej2c(Apellidos_Padre, Apellidos_Madre):- nl, write('Familias en las que la madre trabaja pero el padre no:'), nl,
          familia(persona(_,Apellidos_Padre,_,trabajo(_,0)),
          persona(_,Apellidos_Madre,_,trabajo(_,S)),_),S=\=0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ejercicio 8. % 10 puntos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* 2) Utilizar la base de datos de la anterior forma supone que el usuario sea
conocedor de la estructura interna de la representación. Para paliar esta situación,
definir una serie de procedimientos que facilite la interacción con la base de datos: */

% padre(P) 	P es un hombre casado. Queremos que P se instancie con los datos
%               de la primera persona de la familia;
padre(P) :- familia(P,_,_).
% madre(P) Queremos que P se instancie con los datos de
% la madre;
madre(P) :- familia(_,P,_).
% hijo(P) Queremos que P se instancie con los datos de uno
% de los hijos;
hijo(P) :- familia(_,_,Hijos),member(P,Hijos).
% existe(P) P es una persona que está en la base de datos;
existe(P) :- padre(P); madre(P); hijo(P).
% f_nacimiento(P, F) F es la fecha de nacimiento de la persona P;
f_nacimiento(P, F) :- existe(P), P =persona(_,_,F,_).
% salario(P, S) S es el salario de la persona P.
salario(P, S) :- existe(P),P= persona(_,_,_,trabajo(_,S)).

% a) Encontrar los nombres de todas las personas en la base de datos;
ej3a(Nombre,Apellido) :- nl,write('Nombres de todas las personas de la BD:'),nl,
                         existe(persona(Nombre, Apellido, _, _)).
% b) Encontrar los hijos nacidos después de 1980;
ej3b(Nombre,Apellido,Year) :- nl,write('Hijos nacido despues de 1980'),nl,
                         hijo(persona(Nombre,Apellido,fecha(_,_,Year),_)),Year>1980.
% c)Encontrar todas la mujeres empleadas;
ej3c(Nombre,Apellido,Empleo) :- nl,write('Mujeres empleadas'),nl,
                                madre(persona(Nombre,Apellido,_,trabajo(Empleo,S))),S>0,nl.
% d) Encontrar los nombres de las personas desempleadas nacidas antes de 1970;
ej3d(Nombre,Apellido) :- nl,write('Desempleados nacidos antes de 1970:'),nl,
                         existe(persona(Nombre,Apellido,fecha(_,_,Y),trabajo(T,_))),
                         Y<1970, member(T,[desocupado, en_paro]).

% e) Encontrar las personas nacidas después de 1950 cuyo salario esté comprendido
% entre las 800 y 1300 euros.
ej3e(Nombre,Apellido) :- nl,write('Personas nacidas despues de 1950 y con salario entre 800 y 1300'),nl,
                         existe(persona(Nombre,Apellido,fecha(_,_,Y),trabajo(_,S))), Y>1950, S=<1300, S >= 800.
% f) otra posibilidad
ej3f(Nombre,Apellido) :- salario(persona(Nombre, Apellido, fecha( _, _,Y), _),S), Y > 1950,
                         S >= 800, S =< 1300.
