include "globals.mzn";

set of int : tareas = 1..9;

array[tareas] of var int : duracion = [7, 3, 1, 8, 2, 1, 1, 3, 2];
var int : coste;
var int : indice = 1;


% como se que tienen que estar en orden
array[tareas, 1..2] of var int : predecesoras = [| 0,0 | 1,1 | 2,2 | 1,1 | 3,4 | 3,4 | 3,4 | 1,1 | 6,8 |];

function var int : coste(var int : tarea) = if max([predecesoras[tarea, k] | k in 1..2]) == 0 then duracion[tarea] else if coste(predecesoras[tarea, 1]) > coste(predecesoras[tarea, 2]) then duracion[tarea]+coste(predecesoras[tarea, 1]) else  duracion[tarea]+coste(predecesoras[tarea, 2]) endif endif;

array[tareas] of var 0..9 : orden = sort([predecesoras[k, 2] | k in tareas]);
array[tareas] of var 1..9 : ordenadas;



constraint forall(i in tareas)(forall(j in tareas)(if predecesoras[j, 2] == orden[i] /\ not exists(k in 1..i-1)(orden[k] == predecesoras[j, 2]) then ordenadas[j] == i endif) );




constraint coste == coste(9);


output["Orden (si no aparece un número, por ejemplo el 3, es porque se esta realizando en paralelo con otra tarea) : \n\(ordenadas)\n"];
output["Coste: \(coste)"];

solve minimize coste;