include "globals.mzn";

set of int : vecinos = 1..5;

% enums con los datos que vamos a usar
enum nacionalidades = {vasco, catalan, gallego, navarro, andaluz};
enum animales = {cebra, zorro, caballo, perro, caracoles};
enum bebidas = {agua, te, leche, zumo, cafe};
enum profesiones = {pintor, violinista, medico, diplomatico, escultor};
enum colores = {rojo, amarillo, azul, verde, blanco};


% arrays, uno por cada caracteristica del vecino
array[vecinos] of var nacionalidades : asignacion_nacionalidad;
array[vecinos] of var colores : asignacion_colores;
array[vecinos] of var animales : asignacion_animales;
array[vecinos] of var bebidas : asignacion_bebidas;
array[vecinos] of var profesiones : asignacion_profesiones;


% el vasco tiene la casa roja
% buscamos la casa del vasco
var int : casa_vasco;
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == vasco then casa_vasco == i endif);

% buscamos la casa roja
var int : casa_roja;
constraint forall(i in vecinos)(if asignacion_colores[i] == rojo then casa_roja == i endif);

% hacemos que sean la misma, para que asigne los mismos indices en su respectivo vector al vasco y a la casa roja
constraint casa_vasco == casa_roja;


% el catalan tiene un perro
% igual que antes, buscamos la casa del catalan
var int : casa_catalan;
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == catalan then casa_catalan == i endif);

% buscamos la casa del perro
var int : casa_perro;
constraint forall(i in vecinos)(if asignacion_animales[i] == perro then casa_perro == i endif);

% hacemos que sean la misma, por el mismo motivo antes explicado
constraint casa_catalan == casa_perro;


% el gallego es pintor
% lo resolvemos exactamente igual que los anteriores
var int : casa_gallego;
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == gallego then casa_gallego == i endif);

var int : casa_pintor;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == pintor then casa_pintor == i endif);

constraint casa_gallego == casa_pintor;


% el navarro bebe te
% lo resolvemos exactamente igual que los anteriores
var int : casa_navarro;
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == navarro then casa_navarro == i endif);

var int : casa_te;
constraint forall(i in vecinos)(if asignacion_bebidas[i] == te then casa_te == i endif);

constraint casa_navarro == casa_te;


% andaluz en la primera casa de la izquierda, luego asignamos que en la posicion 1 de nacionalidades está el andaluz
constraint asignacion_nacionalidad[1] == andaluz;


% el de la casa verde bebe cafe
% lo resolvemos exactamente igual que los anteriores
var int : casa_verde;
constraint forall(i in vecinos)(if asignacion_colores[i] == verde then casa_verde == i endif);

var int : casa_cafe;
constraint forall(i in vecinos)(if asignacion_bebidas[i] == cafe then casa_cafe == i endif);

constraint casa_verde == casa_cafe;


% la casa verde esta al lado de la blanca y a su derecha (si i == 5, no hay casa a la derecha)
% lo resolvemos exactamente igual, no es necesario buscar la casa verde ya que la hemos usado en 
% apartados anteriores
var int : casa_blanca;
constraint forall(i in vecinos)(if asignacion_colores[i] == blanco then casa_blanca == i endif);

constraint casa_verde == casa_blanca+1;

% el escultor cria caracoles
% lo resolvemos exactamente igual que los anteriores
var int : casa_escultor;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == escultor then casa_escultor == i endif);

var int : casa_caracoles;
constraint forall(i in vecinos)(if asignacion_animales[i] == caracoles then casa_caracoles == i endif);

constraint casa_escultor == casa_caracoles;


% el diplomatico vive en la casa amarilla
% lo resolvemos exactamente igual que los anteriores
var int : casa_diplomatico;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == diplomatico then casa_diplomatico == i endif);

var int : casa_amarilla;
constraint forall(i in vecinos)(if asignacion_colores[i] == amarillo then casa_amarilla == i endif);

constraint casa_diplomatico == casa_amarilla;

% en la casa central se bebe leche, como tenemos 1..5, la central es la 3
constraint asignacion_bebidas[3] == leche;


% andaluz en la primera casa de la izquierda, la de al lado es la azul, y el andaluz solo tiene una contigua
constraint asignacion_colores[2] == azul;



% el violinista bebe zumo
% lo resolvemos exactamente igual que los anteriores
var int : casa_violinista;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == violinista then casa_violinista == i endif);

var int : casa_zumo;
constraint forall(i in vecinos)(if asignacion_bebidas[i] == zumo then casa_zumo == i endif);

constraint casa_zumo == casa_violinista;



% al lado de la casa del zorro esta la casa del medico
% lo resolvemos exactamente igual que los anteriores, solo que la asignacion será diferente
var int : casa_zorro;
constraint forall(i in vecinos)(if asignacion_animales[i] == zorro then casa_zorro == i endif);

var int : casa_medico;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == medico then casa_medico == i endif);

% en este caso, sabemos que la casa esta al lado, es decir, la distancia absoluta de su resta tiene que valer 1
constraint abs(casa_zorro - casa_medico) == 1;



% al lado de la casa del caballo esta la casa del diplomatico
% lo resolvemos exactamente igual que los anteriores, solo que la asignacion será como en el caso anterior
var int : casa_caballo;
constraint forall(i in vecinos)(if asignacion_animales[i] == caballo then casa_caballo == i endif);

% no tenemos que buscar al diplomatico, lo hemos usado en apartados anteriores

% en este caso, sabemos que la casa esta al lado, es decir, la distancia absoluta de su resta tiene que valer 1
constraint abs(casa_caballo - casa_diplomatico) == 1;


% aplicamos a todos los arrays alldifferent, para que no repita valores
constraint alldifferent(asignacion_nacionalidad);
constraint alldifferent(asignacion_colores);
constraint alldifferent(asignacion_animales);
constraint alldifferent(asignacion_profesiones);
constraint alldifferent(asignacion_bebidas);


% buscamos el indice de la casa donde beben agua y el índice de la casa donde está la cebra
var int : num_casa_agua;
var int : num_casa_cebra;

constraint forall(i in vecinos)(if asignacion_animales[i] == cebra then num_casa_cebra == i endif);
constraint forall(i in vecinos)(if asignacion_bebidas[i] == agua then num_casa_agua == i endif);

% sacamos por pantalla los resultados
output ["Nacionalidades: \([asignacion_nacionalidad[i] | i in 1..5]) \n" ];
output ["Bebidas       : \([asignacion_bebidas[i] | i in 1..5]) \n" ];
output ["Profesion     : \([asignacion_profesiones[i] | i in 1..5]) \n" ];
output ["Mascota       : \([asignacion_animales[i] | i in 1..5]) \n" ];
output ["Color de casa : \([asignacion_colores[i] | i in 1..5]) \n\n" ];


output ["La cebra esta en la casa \(num_casa_cebra), donde vive el \(asignacion_nacionalidad[num_casa_cebra]), que bebe \(asignacion_bebidas[num_casa_cebra]), trabaja en \(asignacion_profesiones[num_casa_cebra]) y tiene la casa pintada de \(asignacion_colores[num_casa_cebra]) \n"];
output ["La persona que bebe agua vive en la casa \(num_casa_agua), es \(asignacion_nacionalidad[num_casa_agua]), tiene como mascota \(asignacion_animales[num_casa_agua]), trabaja en \(asignacion_profesiones[num_casa_agua]) y tiene la casa pintada de \(asignacion_colores[num_casa_agua]) \n"];


solve satisfy;