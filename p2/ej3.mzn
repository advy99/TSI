include "globals.mzn";

set of int : num_profs = 1..6;

% array de los 6 profesores, donde almacenaremos la solucion
% si la solucion es 14 (por ejemplo) quiere decir que da clase
% de 14:00 a 15:00
array[num_profs] of var 9..14 : profesores;
array[num_profs, 1..2] of var 9..15 : horarios;

constraint horarios[1, 1] = 11; constraint horarios[1, 2] = 15;
constraint horarios[2, 1] = 11; constraint horarios[2, 2] = 13;
constraint horarios[3, 1] = 10; constraint horarios[3, 2] = 14;
constraint horarios[4, 1] = 10; constraint horarios[4, 2] = 13;
constraint horarios[5, 1] = 11; constraint horarios[5, 2] = 13;
constraint horarios[6, 1] = 9 ; constraint horarios[6, 2] = 15;


constraint alldifferent(profesores);

constraint forall(i in 1..6)(profesores[i] >= horarios[i, 1] /\ profesores[i] < horarios[i, 2]);


output ["Profesor \(i):\n \t Horario disponible: \(horarios[i, 1]) - \(horarios[i, 2])  \n \t Horario asignado : \(profesores[i]) - \(profesores[i]+1) \n" | i in 1..6];

solve satisfy;