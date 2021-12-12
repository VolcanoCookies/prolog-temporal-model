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

/*
 * all(+List : list, ?Var : element, +Predicate : predicate)
 *
 * Apply the given predicate on all elements of the List, Var will assume each
 * element in List when evaluating Predicate.
 *
 * @param List list to iterate over.
 * @param Var the element we are currently evaluating the predicate on.
 * @param Predicate the predicate to evaluate on the element.
 */
all(List, Var, Predicate) :-
    foreach(member(Var, List), Predicate).
    
/*
 * empty(+List : list)
 *
 * Succeeds if List is a empty list.
 *
 * @param List to check if is empty.
 */
empty([]).

/*
 * next(+Transitions : map, +State : atom, +Blocked : list, -Next : list)
 *
 * Get the states after State, respecting the Blocked list.
 *
 * @param Transitions a map of transitions.
 * @param State Where we are currently.
 * @param Blocked a list of blocked states.
 * @param Next a list of all the next states from State.
 */
next(Transitions, State, Blocked, Next) :-
    entry(Transitions, State, Possible),
    subtract(Possible, Blocked, Next).

/*
 * traverse(+Transitions : map, +State : atom, +Blocked : list, -Path : list, -Var : atom)
 *
 * Traverse the tree starting from State and going to all possible other states.
 *
 * @param Transitions a map of transitions.
 * @param State Where we are currently.
 * @param Blocked a list of blocked states.
 * @param Path a list cosisting of Blocked + any states we traversed to get to Var.
 * @param Var the state we ended up at.
 */
traverse(Transitions, State, Path, Path, State).
traverse(Transitions, State, Visited, Path, Var) :-
    append(Visited, State, NewVisited),
    entry(Transitions, State, Possible),
    member(Next, Possible),
    not(member(Next, NewVisited)),
    traverse(Transitions, Next, NewVisited, Path, Var).
