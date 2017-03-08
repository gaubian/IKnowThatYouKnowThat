%*******************************************************************************
%*                                                                             *
%*                                Toolbox                                      *
%*                                                                             *
%*******************************************************************************


% interval(X,Y,Z) iff X=<Y=<Z
interval(From,From,To) :- From=<To.
interval(From,X,To) :-
  From<To,
  NewFrom is From+1,
  interval(NewFrom,X,To).

factor(N,P1,P2) :-
  % N = P1*P2
  interval(2,P1,sqrt(N)+1),
  0 is N mod P1,
  P2 is N//P1,
  P2<200.


partition(N,S1,S2) :-
  % N = P1 + P2
  max(2,N-199,Lower),
  interval(Lower,S1,N//2),
  S2 is N-S1.

max(X,Y,X) :- X>Y, !.   % max(X,Y,Z) iff Z is the larger of X and Y.
max(X,Y,Y) :- X=<Y.



%*******************************************************************************
%*                                                                             *
%*                   Step number 1: P says: "I don't know"                     *
%*                                                                             *
%*******************************************************************************
% There are multiple ways to factor P

p1(P) :-
  factor(P, X, _),
  factor(P, Y, _),
  X \= Y,
  !.


%*******************************************************************************
%*                                                                             *
%*                   Step number 2: S says: "I knew"                           *
%*                                                                             *
%*******************************************************************************
% So, for each decomposition of the sum, there are at least two ways to factor
% corresponding product, and at least two decompositions of the sum

s1(S) :-
  forall(partition(S,X,Y), p1(X*Y)),
  partition(S,X,_),
  partition(S,Y,_),
  X \= Y,
  !.

%*******************************************************************************
%*                                                                             *
%*                   Step number 3: P says: "Now I know"                       *
%*                                                                             *
%*******************************************************************************
% There is only one way to factor the product such that partitions of
% the sum have a product with multiple factorizations.

p2(P) :-
    findall((X,Y), (factor(P,X,Y), s1(X+Y)),  T),
    T = [_].



%*******************************************************************************
%*                                                                             *
%*                   Step number 4: S says: "Now I also know"                  *
%*                                                                             *
%*******************************************************************************
% Same as last step replacing product by sum.

s2(S) :-
  findall((X,Y), (partition(S,X,Y),(p1(X*Y),p2(X*Y))), T),
  T = [_].

%*******************************************************************************
%*                                                                             *
%*                      Bootstrapping                                          *
%*                                                                             *
%*******************************************************************************
solve(I,J) :-
  interval(2,I,199),
  interval(I,J,199),
  s1(I+J),
  p2(I*J),
  s2(I+J).


