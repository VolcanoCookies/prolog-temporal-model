% Load model, initial state and formula from file.
test_all() :-
    load_files(['./Rules.pl', './Utils.pl']),
    directory_files('./valid', [_|[_|ValidFiles]]),
    directory_files('./invalid', [_|[_|InvalidFiles]]),
    test_valid(ValidFiles),
    test_invalid(InvalidFiles).

test_valid([]).
test_valid([Test|Remaining]) :-
    atom_concat('./valid/', Test, Path),
    (test_file(Path);
    write('\nThe proof is valid but your program rejected it!'), abort),
    test_valid(Remaining).
    
test_invalid([]).
test_invalid([Test|Remaining]) :-
    atom_concat('./invalid/', Test, Path),
    (not(test_file(Path));
    write('\nThe proof is invalid but your program accepted it!'), abort),
    test_invalid(Remaining).

verify(Input) :-
    load_files(['./Rules.pl', './Utils.pl']),
    test_file(Input).

test_file(File) :-
    see(File), read(T), read(L), read(S), read(F), seen,
    (check(T, L, S, [], F), writef('\n%t passed', [File]);
    writef('\n%t failed', [File]), fail).
