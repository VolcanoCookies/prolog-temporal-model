% Catch-All for logging
check(_, _, State, _, Exp) :-
    %writef('\n%t : Currently evaluating %t', [State, Exp]),
    fail.

check(_, Labels, State, _, Exp) :-
    atom(Exp),
    entry(Labels, State, Ls),
    member(Exp, Ls).

check(Transitions, Labels, State, Blocked, neg(Exp)) :-
    not(check(Transitions, Labels, State, Blocked, Exp)).

check(T, L, S, Blocked, and(X1, X2)) :-
    check(T, L, S, Blocked, X1),
    check(T, L, S, Blocked, X2).

check(Transitions, Labels, State, Blocked, or(Exp1, Exp2)) :-
    (check(Transitions, Labels, State, Blocked, Exp1);
    check(Transitions, Labels, State, Blocked, Exp2)).

check(Transitions, Labels, State, Blocked, ax(Exp)) :-
    next(Transitions, State, [], Possible),
    all(Possible, Var, check(Transitions, Labels, Var, [], Exp)).

check(Transitions, Labels, State, Blocked, af(Exp)) :-
    not(member(State, Blocked)),
    check(Transitions, Labels, State, Blocked, Exp).

check(Transitions, Labels, State, Blocked, af(Exp)) :-
    next(Transitions, State, Blocked, Next),
    append(Blocked, State, NewBlocked),
    all(Next, Var, check(Transitions, Labels, Var, NewBlocked, af(Exp))).

check(Transitions, Labels, State, Blocked, ag(Exp)) :-
    member(State, Blocked),
    check(Transitions, Labels, State, Blocked, Exp).

check(Transitions, Labels, State, Blocked, ag(Exp)) :-
    not(member(State, Blocked)),
    check(Transitions, Labels, State, Blocked, Exp),
    append(Blocked, State, NewBlocked),
    next(Transitions, State, NewBlocked, Next),
    all(Next, Var, check(Transitions, Labels, Var, [NewBlocked|Var], ag(Exp))).

check(Transitions, Labels, State, Blocked, ex(Exp)) :-
    next(Transitions, State, Blocked, Possible),
    member(Next, Possible),
    append(Blocked, Next, NewBlocked),
    check(Transitions, Labels, Next, NewBlocked, Exp).

check(Transitions, Labels, State, Blocked, ef(Exp)) :-
    check(Transitions, Labels, State, Blocked, Exp).

check(Transitions, Labels, State, Blocked, ef(Exp)) :-
    traverse(Transitions, State, Blocked, Path, Var),
    not(Var = State),
    check(Transitions, Labels, Var, Path, Exp).

check(Transitions, Labels, State, Blocked, eg(Exp)) :-
    member(State, Blocked),
    check(Transitions, Labels, State, Blocked, Exp).

check(Transitions, Labels, State, Blocked, eg(Exp)) :-
    not(member(State, Blocked)),
    check(Transitions, Labels, State, Blocked, Exp),
    append(Blocked, State, NewBlocked),
    traverse(Transitions, State, NewBlocked, Path, Var),
    check(Transitions, Labels, Var, Path, Exp).

%check(_, L, S, [], X) :- ...
%check(_, L, S, [], neg(X)) :- ...
% And
%check(T, L, S, [], and(F,G)) :- ...
% Or
% AX
% EX
% AG
% EG
% EF
% AF
