/**
 * list(+List : list).
 *
 * Succeeds if List is in fact a list.
 *
 * @param List the object to check if its a list.
 */
is_list([]).
is_list([_|_]).

/**
 * all_match(+List : list, +Predicate : any).
 *
 * Succeeds if all elements in the list match the predicate provided.
 *
 * @param List the list to check in.
 * @param Predicate the predicate all elements in the list must match.
 */
all_match([], _).
all_match([Predicate|T], Predicate) :-
    all_match(T, Predicate).

/**
 * until(+List : list, +Element : any, -Sublist : list).
 *
 * Get all elements until Element from List. Fails if Element is not in List.
 *
 * Excluding Element.
 *
 * @param List the list to get a sublist of.
 * @param Element the element to go until.
 * @param Sublist the returned sublist, excludes Element.
 */
until(List, Element, Sublist) :-
    until(List, Element, [], Sublist).
until([Elm|_], Elm, Acc, Acc).
until([H|T], Elm, Acc, Sub) :-
    append(H, Acc, New),
    until(T, Elm, New, Sub).

/**
 * append(+List : list, +Element : any, -Result : list).
 *
 * Appends Element to the end of List.
 *
 * @param List the list to append Element to.
 * @param Element the element to append.
 * @param Result the resulting new list.
 */
append([], L, [L]).
append([H|T], L, [H|R]) :-
      append(T, L, R).

/**
 * is_box(+Box : list).
 *
 * Succeeds if Box is a list where the first element is not a integer.
 *
 * @param Box the potential box.
 */
is_box([H|_]) :-
    not(integer(H)).

/**
 * contains(+List : list, ?Element : any).
 *
 * Succeeds if List contains Element.
 *
 * @param List the list to check in.
 * @param Element the element to find in the list, or match.
 */
contains([H|_], H).
contains([_|T], E) :-
    contains(T, E).

/**
 * deep_contains(+List : list, ?Element : any).
 *
 * Succeeds if List, or any sublists in List, contains Element.
 *
 * @param List the list to check in, will check any sublists.
 * @param Element the element to find, or match.
 */
deep_contains([H|_], H).
deep_contains([H|T], E) :-
    deep_contains(H, E) ;
    deep_contains(T, E).

/**
 * last(+List : list, ?Element : any).
 *
 * Succeeds if the last element in List equals Element.
 *
 * @param List the list to get the last element from.
 * @param Element the last element.
 */
last([H|[]], H).
last([_|T], E) :-
    last(T, E).

/*
 * entry(+Map : map, ?Key : element, ?Value : element)
 *
 * Succeeds if a entry exists in map with either key or value.
 *
 * @param Map to look in.
 * @param Key to retrieve or fetch.
 * @param Value to retrieve of fetch.
 */
entry([[Key, Value]|_], Key, Value).
entry([_|Next], Key, Value) :-
    entry(Next, Key, Value).

any([Elem|_], Elem, Goal) :-
    Goal.
any([_|T], Elem, Goal) :-
    any(T, Elem, Goal).

all(List, Var, Predicate) :-
    foreach(member(Var, List), Predicate).

empty([]).

next(Transitions, State, Blocked, Next) :-
    entry(Transitions, State, Possible),
    subtract(Possible, Blocked, Next).

traverse(Transitions, State, Path, Path, State).
traverse(Transitions, State, Visited, Path, Var) :-
    append(Visited, State, NewVisited),
    entry(Transitions, State, Possible),
    member(Next, Possible),
    not(member(Next, NewVisited)),
    traverse(Transitions, Next, NewVisited, Path, Var).

all_traverse(Transitions, Start, Start, Path, Predicate) :-
    Predicate,
    all_traverse(Transitions, Start, Var, [Predicate], Path, Predicate).
all_traverse(Transitions, Start, Start, Path, Path, Predicate) :-
    Predicate.
all_traverse(Transitions, Current, Next, Visited, Path, Predicate) :-
    entry(Transitions, Current, Next),
    not(contains(Next, Visited)),
    (Predicate; abort),
    append(Visited, Next, NewVisited),
    all_traverse(Transitions, Next, _, NewVisited, Path, Predicate).

any_node(Transitions, Entry, Var, Predicate, End) :-
    any_node(Transitions, Entry, Var, [Entry], Predicate, End).
any_node(Transitions, Current, Current, _, Predicate, Current) :-
    Predicate.
any_node(Transitions, Current, Current, Visited, Predicate, End) :-
    entry(Transitions, Current, Next),
    not(member(Next, Visited)),
    append(Next, Visited, NewVisited),
    any_node(Transitions, Next, Next, Visited, Predicate, End).


pair(A, B, [A|B]).

nodes(List, Nodes) :-
    nodes(List, [], Nodes).
nodes([], Nodes, Nodes).
nodes([[N|_]|T], Acc, Nodes) :-
    append(Acc, N, NewAcc),
    nodes(T, NewAcc, Nodes).

subsequents(Transitions, State, Subsequents) :-
    entry(Transitions, State, Subsequents).

threads(Transitions, State, Threads) :-
    findall(Thread, thread(Transitions, State, Thread), Threads).

thread(Transitions, State, Thread) :-
    nodes(Transitions, Nodes),
    maplist(pair, Nodes, Nodes, Traversed),
    thread(Transitions, State, State, [], Traversed, Thread).
thread(Transitions, _, _, Visited, _, Visited) :-
    empty(Transitions).
thread(Transitions, _, State, Visited, Traversed, Visited) :-
    not(empty(Visited)),
    entry(Transitions, State, Dest),
    delete(Dest, Initial, F),
    maplist(pair(State), F, Possible),
    subtract(Possible, Traversed, Remaining),
    empty(Remaining).
thread(Transitions, Initial, State, Visited, Traversed, Thread) :-
    entry(Transitions, State, Dest),
    delete(Dest, Initial, F),
    maplist(pair(State), F, Possible),
    subtract(Possible, Traversed, Remaining),
    member([_|Next], Remaining),
    %(length(Remaining, 1),
    %delete(Transitions, [State|_], NewTransitions);
    %NewTransitions = Transitions),
    append(Traversed, [State|Next], NewTraversed),
    append(Visited, Next, NewVisited),
    thread(Transitions, Initial, Next, NewVisited, NewTraversed, Thread).


paths(Transitions, State, Paths) :-
    findall(Path, path(Transitions, State, Path), Paths).

path(Transitions, State, Path) :-
    path(Transitions, State, [], [], Path).
path(_, _, Traversed, _, Traversed) :-
    not(empty(Traversed)).
path(Transitions, State, Traversed, Transitioned, Path) :-
    entry(Transitions, State, Possible),
    member(Next, Possible),
    not(contains(Transitioned, [State, Next])),
    append(Transitioned, [State, Next], NewTransitioned),
    append(Traversed, Next, NewTraversed),
    path(Transitions, Next, NewTraversed, NewTransitioned, Path).

reachable(Transitions, State, Reachable) :-
    reachable(Transitions, [State], [], Reachable).
reachable(Transitions, [], Reachable, Reachable).
reachable(Transitions, [H|T], Seen, Reachable) :-
    entry(Transitions, H, Subsequents),
    append(Seen, H, NewSeen),
    union(Subsequents, T, Union),
    subtract(Union, NewSeen, NewVisit),
    reachable(Transitions, NewVisit, NewSeen, Reachable).
    
