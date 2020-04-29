include "globals.mzn";

% numero de objetos que tenemos
set of int : num_objetos = 1..12;

% pesos de los objetos
array[num_objetos] of int : pesos = [9, 13, 153, 50, 15, 68, 27, 39, 23, 52, 11, 32];

% preferencias de los objetos
array[num_objetos] of int : preferencias = [150, 35, 200, 160, 60, 45, 60, 40, 30, 10, 70, 30];

% peso máximo
int : peso_maximo = 275;

% variable para contar el peso que tenemos
var int : peso_actual;

% variable de bool, false significa que no esta en la mochila, true que si lo está
array[num_objetos] of var bool : seleccionados;

% el peso actual es la suma de los pesos que están seleccionados
peso_actual = sum(i in num_objetos)(if seleccionados[i] == true then pesos[i] else 0 endif);

% queremos que el peso sea menor o igual al peso máximo
constraint peso_actual <= peso_maximo;

% la preferencia es la suma de las preferencias de los objetos en la mochila
var int : preferencia;
preferencia = sum(i in num_objetos)(if seleccionados[i] == true then preferencias[i] else 0 endif);

% lo resolvemos maximizando la preferencia
solve maximize preferencia;