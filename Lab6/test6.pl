test(X) :- X=a, write("has escrito a").
test(X) :- X=b, write("has escrito b").
test(_) :- write("has escrito otra cosa").


test2(X) :- X=a,!, write("has escrito a").
test2(X) :- X=b, !, write("has escrito b").
test2(_) :- write("has escrito otra cosa").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%version 1
%ifthenElse1(cond, acc,acc)
% if condicion then accion1 else accion2
ifThenElse1(C,A1,_) :- C,!,A1.
ifThenElse1(_,_,A2) :- A2.

%ifthenElse predifinido en prolog "->"
% (C->A1;A2).
%Negacion not(p(a)) o \t(p(a))
hombre(juan).
mujer(maria).
not(A):-A,!,fail.
not(A).

f( X , Y ) :- ( X < 3 -> Y = 0 ;
3 =< X , X < 6 -> Y = 2 ;
otherwise -> Y = 4 ).

add(X,L,L1):-member(X,L)->L1=L;L1=[X|L].
add2(X,L,L):-member(X,L),!.
add2(X,L,[X|L]).

cubo:- write('inserte un numero: '),
       read(X),
       (X= stop,!,true;
        (eleva(X),cubo)).

cubo2:-repeat,write('inserte un numero: '),read(X),
      (X=stop,!;eleva(X),fail).


eleva(X):- Cubo_N is X**3,write('el cubo de '),write(X),write(' es '),write(Cubo_N),nl.


%%%%%%%%%%%TEXTO%%%%%%%%%%%%%%%%%%%
cont(Fichero,Carac,Palab,Lineas):-
  (see(Fichero),!,
    tratamiento(0,0,0,Carac,Palab,Lineas);
    seen,quit),
  seen,
  write('Numero de Caracteres: '),write(Carac),nl,
  write('Numero de Palabras:   '),write(Palab),nl,
  write('Numero de Lineas:     '),write(Lineas),nl.

tratamiento(Cont_c,Cont_p,Cont_l,Carac,Palab,Lineas):-
  get0(C),
  (C == -1,!,
    Carac=Cont_c,Palab=Cont_p,Lineas=Cont_l;
    member(C,[32,40,41,44,46,59,191,63]),!,
    CC is Cont_c+1,
    tratamiento(CC,Cont_p,Cont_l,Carac,Palab,Lineas);
    C = 10,!,
    CC is Cont_c+1,CL is Cont_l+1,
    tratamiento(CC,Cont_p,CL,Carac,Palab,Lineas);
    palabra(1,Total,Delimitador),
    (Delimitador = -1,!,CC is Total+Cont_c;CC is Cont_c+Total+1),
    CP is Cont_p+1,
    ((Delimitador = 10; Delimitador= -1),!,CL is Cont_l+1;CL = Cont_l),
    tratamiento(CC,CP,CL,Carac,Palab,Lineas)
  ).

  palabra(CC1, Total, Delimitador) :-
  	get0(C), tot_palabra(C, CC1, Total, Delimitador).
  tot_palabra(-1, CC1, CC1, -1) :-  !.   %% fin_fichero
  tot_palabra(C, CC1, CC1, C) :-
  	member(C, [10, 32, 40, 41, 44, 46, 59, 191, 63]), !.
  tot_palabra(_, CC1, Total, Delimitador) :-
  	CC2 is CC1 + 1,
  	palabra(CC2,Total, Delimitador).


componentes(Fichero,ListaPalabras) :- see(Fichero), obtener(ListaPalabras), seen.

obtener(L) :- obtenerPalabra(W), (W == -1 -> (L = [], !) ; (obtener(Resto),L=[W|Resto])).

obtenerPalabra(Palabra) :- saltarDelimitadores(C),
                          (C == -1 -> Palabra = -1,!;
                          (get0(X),leerPalabra(X,ListaCarac), atom_chars(Palabra,[C|ListaCarac]))).
leerPalabra(X,L) :- (member(X,[32,44,46,59,10]) -> L=[] ; (get0(Y), leerPalabra(Y,L2), append([X],L2,L))).
saltarDelimitadores(C) :- get0(X),(member(X,[32,44,46,59,10]) -> saltarDelimitadores(C); C is X).
