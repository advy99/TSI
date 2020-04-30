include "globals.mzn";

int : hora_comienzo = 8;

int : hora_fin = hora_comienzo+5;

set of int : dias_semana = 1..5;

set of int : horas_clase = hora_comienzo..hora_fin;

set of int : num_asignaturas = 1..9;

array[num_asignaturas] of 1..4 : horas_necesarias = [4, 2, 4, 4, 4, 2, 2, 2, 1];


array[horas_clase] of var 0..9 : lunes;
array[horas_clase] of var 0..9 : martes;
array[horas_clase] of var 0..9 : miercoles;
array[horas_clase] of var 0..9 : jueves;
array[horas_clase] of var 0..9 : viernes;

%array[dias_semana, horas_clase] of var 0..9 : asignacion;


% la hora del recreo es la cuarta hora, si comenzamos a las 8, de 11 a 12
constraint lunes[hora_comienzo+3] == 0;
constraint martes[hora_comienzo+3] == 0;
constraint miercoles[hora_comienzo+3] == 0;
constraint jueves[hora_comienzo+3] == 0;
constraint viernes[hora_comienzo+3] == 0;




% en un dia solo se puede impartir un bloque y los bloques de la 2, 6, 7 y 9 son de 1 hora, mientras que los demas de dos
constraint forall(i in num_asignaturas)(if i == 2 \/ i == 6 \/ i == 7 \/ i == 9 then count( lunes, i) <= 1 else count( lunes, i) == 2 \/ count( lunes, i) == 0 endif );
constraint forall(i in num_asignaturas)(if i == 2 \/ i == 6 \/ i == 7 \/ i == 9 then count( martes, i) <= 1 else count( martes, i) == 2 \/ count( martes, i) == 0 endif);
constraint forall(i in num_asignaturas)(if i == 2 \/ i == 6 \/ i == 7 \/ i == 9 then count( miercoles, i) <= 1 else count( miercoles, i) == 2 \/ count( miercoles, i) == 0 endif);
constraint forall(i in num_asignaturas)(if i == 2 \/ i == 6 \/ i == 7 \/ i == 9 then count( jueves, i) <= 1 else count( jueves, i) == 2 \/ count( jueves, i) == 0 endif);
constraint forall(i in num_asignaturas)(if i == 2 \/ i == 6 \/ i == 7 \/ i == 9 then count( viernes, i) <= 1 else count( viernes, i) == 2 \/ count( viernes, i) == 0 endif);


array[1..5] of var int : bloques_dos_horas = [1, 3, 4, 5, 8];

constraint forall(j in 1..5)(forall(i in hora_comienzo+1..hora_fin-1)(if lunes[i] == bloques_dos_horas[j] then lunes[i+1] == bloques_dos_horas[j] \/ lunes[i-1] == bloques_dos_horas[j] endif));

constraint forall(j in 1..5)(forall(i in hora_comienzo+1..hora_fin-1)(if martes[i] == bloques_dos_horas[j] then martes[i+1] == bloques_dos_horas[j] \/ martes[i-1] == bloques_dos_horas[j] endif));

constraint forall(j in 1..5)(forall(i in hora_comienzo+1..hora_fin-1)(if miercoles[i] == bloques_dos_horas[j] then miercoles[i+1] == bloques_dos_horas[j] \/ miercoles[i-1] == bloques_dos_horas[j] endif));

constraint forall(j in 1..5)(forall(i in hora_comienzo+1..hora_fin-1)(if jueves[i] == bloques_dos_horas[j] then jueves[i+1] == bloques_dos_horas[j] \/ jueves[i-1] == bloques_dos_horas[j] endif));

constraint forall(j in 1..5)(forall(i in hora_comienzo+1..hora_fin-1)(if viernes[i] == bloques_dos_horas[j] then viernes[i+1] == bloques_dos_horas[j] \/ viernes[i-1] == bloques_dos_horas[j] endif));


% restricciones del profesor 1, si un dia da una clase de A1, no puede dar clase de A3
constraint if count(lunes, 1) != 0 then count(lunes, 3) == 0 endif;
constraint if count(martes, 1) != 0 then count(martes, 3) == 0 endif;
constraint if count(miercoles, 1) != 0 then count(miercoles, 3) == 0 endif;
constraint if count(jueves, 1) != 0 then count(jueves, 3) == 0 endif;
constraint if count(viernes, 1) != 0 then count(viernes, 3) == 0 endif;



% restricciones del profesor 2
constraint if count(lunes, 4) != 0 then count(lunes, 5) == 0 endif;
constraint if count(martes, 4) != 0 then count(martes, 5) == 0 endif;
constraint if count(miercoles, 4) != 0 then count(miercoles, 5) == 0 endif;
constraint if count(jueves, 4) != 0 then count(jueves, 5) == 0 endif;
constraint if count(viernes, 4) != 0 then count(viernes, 5) == 0 endif;

% restricciones del profesor 3
constraint if count(lunes, 6) != 0 then count(lunes, 9) == 0 endif;
constraint if count(martes, 6) != 0 then count(martes, 9) == 0 endif;
constraint if count(miercoles, 6) != 0 then count(miercoles, 9) == 0 endif;
constraint if count(jueves, 6) != 0 then count(jueves, 9) == 0 endif;
constraint if count(viernes, 6) != 0 then count(viernes, 9) == 0 endif;

constraint viernes[hora_comienzo+1] == 8;
constraint viernes[hora_comienzo+2] == 8;
constraint viernes[hora_fin] == 9;

constraint forall(x in 1..7)( horas_necesarias[x] == count(lunes, x) + count(martes, x) + count(miercoles, x) + count(jueves, x) + count(viernes, x)); 


output ["Lunes: \n \t \(lunes) \n"];
output ["Martes: \n \t \(martes) \n"];
output ["Miercoles: \n \t \(miercoles)\n"];
output ["Jueves: \n \t \(jueves)\n"];
output ["Viernes: \n \t \(viernes)\n"];

solve satisfy;

