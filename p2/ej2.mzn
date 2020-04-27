include "globals.mzn";

% array que simulará X
array[0..9] of var 0..9 : x;

constraint forall(i in 0..9)(x[i] == count(x, i));

output ["X = \(x) "];

solve satisfy;