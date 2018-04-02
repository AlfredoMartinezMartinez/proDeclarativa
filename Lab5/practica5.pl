invertir_recur([],[]).
invertir_recur([X,|Xs],I) :- invertir(Xs, IXs), append(IXs,[X],I).


% invertir( L,I) :- invertir(L,[],I).
%invertir (L,A,I)
% invertir([],A,I):- I=A.
% invertir([X|Xs],A,I) :- NewL=Xs,NewA=[X|A],invertir(NewL,NewA,I).

%otra manera--programdores prolog unificacion en cabeza antes que en cuerpo
invertir([],A,A).
invertir([X|Xs],A,I):-invertir(Xs,[X|A],I).
