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

%array[1..13] of string : asignaturas = ["IA1", "TSI1", "FBD1", "IA2", "TSI1", "FBD2", "IA3", "TSI3", "FBD3", "IA4", "TSI4", "FBD4", "NADA"];

array[1..4] of int : profesor1 = [1, 2, 4, 5];
array[1..2] of int : profesor2 = [3, 6];
array[1..4] of int : profesor3 = [8, 9, 11, 12];
array[1..2] of int : profesor4 = [7, 10];

array[num_profs, num_aulas] of var 0..12 : asignacion_9;
array[num_profs, num_aulas] of var 0..12 : asignacion_10;
array[num_profs, num_aulas] of var 0..12 : asignacion_11;
array[num_profs, num_aulas] of var 0..12 : asignacion_12;

array[horas_disponibles] of var int: aula1;
array[horas_disponibles] of var int: aula2;
array[horas_disponibles] of var int: aula3;
array[horas_disponibles] of var int: aula4;

array[num_aulas, horas_disponibles] of var 0..12 : asignaciones;


% lo que se da en un aula en las mismas horas tiene que ser distinto
constraint forall(i in num_aulas)(alldifferent([asignaciones[i, j] | j in horas_disponibles ]));
% constraint forall(i in horas_disponibles)(aula1[i] != aula2[i] /\ aula1[i] != aula3[i] /\ aula1[i] != aula4[i]);
% constraint forall(i in horas_disponibles)(aula2[i] != aula3[i] /\ aula2[i] != aula4[i]);
% constraint forall(i in horas_disponibles)(aula3[i] != aula4[i]);


% si en la hora i se imparte la clase j del grupo 1 en el aula 1 
constraint forall(i in horas_disponibles)(if asignaciones[1, i] == 1 \/ asignaciones[1, i] == 2 \/ asignaciones[1, i] == 3  then forall(k in 2..4, j in 1..3)(asignaciones[k, i] != j /\ asignaciones[k, i] != j /\ asignaciones[k, i] != j) endif);

% si en la hora i se imparte la clase j del grupo 1 en el aula 1 
constraint forall(i in horas_disponibles)(if aula1[i] == 1 \/ aula1[i] == 2 \/ aula1[i] == 3  then forall(j in 1..3)(aula2[i] != j) /\ forall(j in 1..3)(aula3[i] != j) /\ forall(j in 1..3)(aula4[i] != j) endif);

% si en la hora i se imparte la clase j del grupo 1 en el aula 1 
constraint forall(i in horas_disponibles)(if aula1[i] == 1 \/ aula1[i] == 2 \/ aula1[i] == 3  then forall(j in 1..3)(aula2[i] != j) /\ forall(j in 1..3)(aula3[i] != j) /\ forall(j in 1..3)(aula4[i] != j) endif);

% si en la hora i se imparte la clase j del grupo 1 en el aula 1 
constraint forall(i in horas_disponibles)(if aula1[i] == 1 \/ aula1[i] == 2 \/ aula1[i] == 3  then forall(j in 1..3)(aula2[i] != j) /\ forall(j in 1..3)(aula3[i] != j) /\ forall(j in 1..3)(aula4[i] != j) endif);


% cada asignatura aparece solo una vez
constraint forall(x in 1..12)(1 == count([asignaciones[i,j+8] | i, j in num_aulas], x));


output ["Aula \(i): \([asignaciones[i, j] | j in horas_disponibles]) \n\n" | i in num_aulas];

solve satisfy;