include "globals.mzn";

set of int : num_objetos = 1..12;

array[num_objetos] of int : pesos = [9, 13, 153, 50, 15, 68, 27, 39, 23, 52, 11, 32];

array[num_objetos] of int : preferencias = [150, 35, 200, 160, 60, 45, 60, 40, 30, 10, 70, 30];


int : peso_maximo = 275;
var int : peso_actual;
array[num_objetos] of var bool : seleccionados;


peso_actual = sum(i in num_objetos)(if seleccionados[i] == true then pesos[i] else 0 endif);

constraint peso_actual <= peso_maximo;


var int : preferencia;
preferencia = sum(i in num_objetos)(if seleccionados[i] == true then preferencias[i] else 0 endif);


solve maximize preferencia;