include "globals.mzn";

% apartado a)
% numero de profesores
set of int : num_profs = 1..4;

% numero de aulas
set of int : num_aulas = 1..4;

% horas disponibles, las 9:00 representan la franja 9:00 - 10:00
% por eso va hasta 12, que sería 12:00 - 13:00
set of int : horas_disponibles = 9..12;


% apartado b)
% array donde las filas representan las aulas, y las columnas las horas asignadas
% cada casilla solo puede tener un valor, luego solucionamos el apartado b
int : IA1 = 1;
int : TSI1 = 2;
int : FBD1 = 3;

int : IA2 = 4;
int : TSI2 = 5;
int : FBD2 = 6;

int : IA3 = 7;
int : TSI3 = 8;
int : FBD3 = 9;

int : IA4 = 10;
int : TSI4 = 11;
int : FBD4 = 12;



array[num_aulas, horas_disponibles] of var 0..12 : asignaciones;


% lo que se da en un aula en las mismas horas tiene que ser distinto
constraint forall(i in num_aulas)(alldifferent([asignaciones[i, j] | j in horas_disponibles ]));
% constraint forall(i in horas_disponibles)(aula1[i] != aula2[i] /\ aula1[i] != aula3[i] /\ aula1[i] != aula4[i]);
% constraint forall(i in horas_disponibles)(aula2[i] != aula3[i] /\ aula2[i] != aula4[i]);
% constraint forall(i in horas_disponibles)(aula3[i] != aula4[i]);


% si en la hora i se imparte la clase j del grupo 1 en el aula "aula", comprobamos un aula con las siguientes, la 1 con la 2, 3 y 4, la 2 con la 3 y 4, y la 3 con la 4
% no es necesario la 2 con la 1, porque ya hemos visto 1 con 2
constraint forall(i in horas_disponibles)(forall(aula in num_aulas)(if asignaciones[aula, i] == 1 \/ asignaciones[aula, i] == 2 \/ asignaciones[aula, i] == 3  then forall(k in aula+1..4)(forall(j in 1..3)(asignaciones[k, i] != j)) endif));

% si en la hora i se imparte la clase j del grupo 2 en el aula "aula", comprobamos un aula con las siguientes, la 1 con la 2, 3 y 4, la 2 con la 3 y 4, y la 3 con la 4
% no es necesario la 2 con la 1, porque ya hemos visto 1 con 2
constraint forall(i in horas_disponibles)(forall(aula in num_aulas)(if asignaciones[aula, i] == 4 \/ asignaciones[aula, i] == 5 \/ asignaciones[aula, i] == 6  then forall(k in aula+1..4)(forall(j in 4..6)(asignaciones[k, i] != j)) endif));


% si en la hora i se imparte la clase j del grupo 3 en el aula "aula", comprobamos un aula con las siguientes, la 1 con la 2, 3 y 4, la 2 con la 3 y 4, y la 3 con la 4
% no es necesario la 2 con la 1, porque ya hemos visto 1 con 2
constraint forall(i in horas_disponibles)(forall(aula in num_aulas)(if asignaciones[aula, i] == 7 \/ asignaciones[aula, i] == 8 \/ asignaciones[aula, i] == 9  then forall(k in aula+1..4)(forall(j in 7..9)(asignaciones[k, i] != j)) endif));


% si en la hora i se imparte la clase j del grupo 4 en el aula "aula", comprobamos un aula con las siguientes, la 1 con la 2, 3 y 4, la 2 con la 3 y 4, y la 3 con la 4
% no es necesario la 2 con la 1, porque ya hemos visto 1 con 2
constraint forall(i in horas_disponibles)(forall(aula in num_aulas)(if asignaciones[aula, i] == 10 \/ asignaciones[aula, i] == 11 \/ asignaciones[aula, i] == 12  then forall(k in aula+1..4)(forall(j in 10..12)(asignaciones[k, i] != j)) endif));

% el profesor 2 no puede a las 10, y da FDB1 y FBD2
constraint forall(aula in num_aulas)(asignaciones[aula, 10] != FBD1 /\ asignaciones[aula, 10] != FBD2);


% el profesor 4 no puede a las 9, y da IA3 e IA4
constraint forall(aula in num_aulas)(asignaciones[aula, 9] != IA3 /\ asignaciones[aula, 9] != IA4);


% en las horas donde se de una de entre IA1, IA2, TSI1 o TSI2 no se pueden dar las demas, porque las da el mismo profesor
constraint forall(i in horas_disponibles)(forall(aula in num_aulas)(if asignaciones[aula, i] == IA1 \/ asignaciones[aula, i] == IA2 \/ asignaciones[aula, i] == TSI1 \/ asignaciones[aula, i] == TSI2  then forall(k in aula+1..4)(asignaciones[k, i] != IA1 /\ asignaciones[k, i] != IA2 /\ asignaciones[k, i] != TSI1 /\ asignaciones[k, i] != TSI2) endif));

% en las horas donde se de una de entre FBD1 o FBD2 no se pueden dar las demas, porque las da el mismo profesor
constraint forall(i in horas_disponibles)(forall(aula in num_aulas)(if asignaciones[aula, i] == FBD1 \/ asignaciones[aula, i] == FBD2 then forall(k in aula+1..4)(asignaciones[k, i] != FBD1 /\ asignaciones[k, i] != FBD2) endif));

% en las horas donde se de una de entre TSI3, TSI4, FBD3 o FBD4 no se pueden dar las demas, porque las da el mismo profesor
constraint forall(i in horas_disponibles)(forall(aula in num_aulas)(if asignaciones[aula, i] == TSI3 \/ asignaciones[aula, i] == TSI4 \/ asignaciones[aula, i] == FBD3 \/ asignaciones[aula, i] == FBD4  then forall(k in aula+1..4)(asignaciones[k, i] != TSI3 /\ asignaciones[k, i] != TSI4 /\ asignaciones[k, i] != FBD3 /\ asignaciones[k, i] != FBD4) endif));

% en las horas donde se de una de entre IA3 o IA4 no se pueden dar las demas, porque las da el mismo profesor
constraint forall(i in horas_disponibles)(forall(aula in num_aulas)(if asignaciones[aula, i] == IA3 \/ asignaciones[aula, i] == IA4 then forall(k in aula+1..4)(asignaciones[k, i] != IA3 /\ asignaciones[k, i] != IA4) endif));


% cada asignatura aparece solo una vez
constraint forall(x in 1..12)(1 == count([asignaciones[i,j+8] | i, j in num_aulas], x));


output ["9:00: \n"];
output ["\([asignaciones[i, 9]])  " |  i in num_aulas];

output ["\n\n10:00 : \n"];
output ["\([asignaciones[i, 10]])  " |  i in num_aulas];

output ["\n\n11:00 : \n"];
output ["\([asignaciones[i, 11]])  " |  i in num_aulas];

output ["\n\n12:00 : \n"];
output ["\([asignaciones[i, 12]])  " |  i in num_aulas];

output ["\n\n Asignaciones: Nada = 0, IA1 = 1, TSI1 = 2, FBD1 = 3, IA2 = 4, TSI2 = 5, FBD2 = 6, IA3 = 7, TSI3 = 8, FBD3 = 9, IA4 = 10, TSI4 = 11, FBD4 = 12,  " ];
output ["\nClases del profesor 1 : IA1, IA2, TSI1, TSI2"];
output ["\nClases del profesor 2 : FBD1, FBD2"];
output ["\nClases del profesor 3 : TSI3, TSI4, FBD3, FBD4"];
output ["\nClases del profesor 4 : IA3, IA4"];


solve satisfy;