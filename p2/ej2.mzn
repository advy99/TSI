include "globals.mzn";

% array que simulará X
array[0..9] of var 0..9 : x;

% la posicion i en x tiene que ser igual al número de veces que aparece i en el vector
% por ejemplo, la posicion 0 tiene que contener el número  de veces que aparece 0 en el vector
constraint forall(i in 0..9)(x[i] == count(x, i));

output ["X = \(x) "];

solve satisfy;