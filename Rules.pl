% Catch-All for logging
check(_, _, State, _, Exp) :-
    %writef('\n%t : %t', [State, Exp]),
    fail.

check(_, Labels, State, _, Exp) :-
    atom(Exp),
    entry(Labels, State, Ls),
    member(Exp, Ls).

check(Transitions, Labels, State, Blocked, neg(Exp)) :-
    not(check(Transitions, Labels, State, Blocked, Exp)).

check(Transitions, Labels, State, _, and(Exp1, Exp2)) :-
    check(Transitions, Labels, State, [], Exp1),
    check(Transitions, Labels, State, [], Exp2).

check(Transitions, Labels, State, Blocked, or(Exp1, Exp2)) :-
    (check(Transitions, Labels, State, Blocked, Exp1);
    check(Transitions, Labels, State, Blocked, Exp2)).

check(Transitions, Labels, State, _, ax(Exp)) :-
    next(Transitions, State, [], Possible),
    not(empty(Possible)),
    all(Possible, Var, check(Transitions, Labels, Var, [], Exp)).

check(Transitions, Labels, State, Blocked, af(Exp)) :-
    not(member(State, Blocked)),
    check(Transitions, Labels, State, [], Exp).

check(Transitions, Labels, State, Blocked, af(Exp)) :-
    not(member(State, Blocked)),
    next(Transitions, State, [Blocked], Next),
    not(empty(Next)),
    all(Next, Var, check(Transitions, Labels, Var, [State|Blocked], af(Exp))).

check(Transitions, Labels, State, Blocked, ag(Exp)) :-
    member(State, Blocked),
    check(Transitions, Labels, State, [], Exp).

check(Transitions, Labels, State, Blocked, ag(Exp)) :-
    not(member(State, Blocked)),
    check(Transitions, Labels, State, [], Exp),
    next(Transitions, State, [], Next),
    not(empty(Next)),
    all(Next, Var, check(Transitions, Labels, Var, [State|Blocked], ag(Exp))).

check(Transitions, Labels, State, _, ex(Exp)) :-
    next(Transitions, State, [], Possible),
    member(Next, Possible),
    check(Transitions, Labels, Next, [State], Exp).

check(Transitions, Labels, State, Blocked, ef(Exp)) :-
    not(member(State, Blocked)),
    check(Transitions, Labels, State, [], Exp).

check(Transitions, Labels, State, Blocked, ef(Exp)) :-
    not(member(State, Blocked)),
    next(Transitions, State, [], Next),
    member(Var, Next),
    check(Transitions, Labels, Var, [State|Blocked], ef(Exp)).

check(Transitions, Labels, State, Blocked, eg(Exp)) :-
    member(State, Blocked),
    check(Transitions, Labels, State, [], Exp).

check(Transitions, Labels, State, Blocked, eg(Exp)) :-
    not(member(State, Blocked)),
    check(Transitions, Labels, State, [], Exp),
    next(Transitions, State, [], Next),
    member(Var, Next),
    check(Transitions, Labels, Var, [State|Blocked], eg(Exp)).
