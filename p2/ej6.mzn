include "globals.mzn";

set of int : vecinos = 1..5;

enum nacionalidades = {vasco, catalan, gallego, navarro, andaluz};
enum animales = {cebra, zorro, caballo, perro, caracoles};
enum bebidas = {agua, te, leche, zumo, cafe};
enum profesiones = {pintor, violinista, medico, diplomatico, escultor};
enum colores = {rojo, amarillo, azul, verde, blanco};


array[vecinos] of var nacionalidades : asignacion_nacionalidad;
array[vecinos] of var colores : asignacion_colores;
array[vecinos] of var animales : asignacion_animales;
array[vecinos] of var bebidas : asignacion_bebidas;
array[vecinos] of var profesiones : asignacion_profesiones;


% el vasco tiene la casa roja
%constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == vasco then asignacion_colores[i] == rojo endif);
var int : casa_vasco;
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == vasco then casa_vasco == i endif);

var int : casa_roja;
constraint forall(i in vecinos)(if asignacion_colores[i] == rojo then casa_roja == i endif);

constraint casa_vasco == casa_roja;


% el catalan tiene un perro
%constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == catalan then asignacion_animales[i] == perro endif);
var int : casa_catalan;
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == catalan then casa_catalan == i endif);

var int : casa_perro;
constraint forall(i in vecinos)(if asignacion_animales[i] == perro then casa_perro == i endif);

constraint casa_catalan == casa_perro;


% el gallego es pintor
%constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == gallego then asignacion_profesiones[i] == pintor endif);
var int : casa_gallego;
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == gallego then casa_gallego == i endif);

var int : casa_pintor;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == pintor then casa_pintor == i endif);

constraint casa_gallego == casa_pintor;


% el navarro bebe te
%constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == navarro then asignacion_bebidas[i] == te endif);
var int : casa_navarro;
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == navarro then casa_navarro == i endif);

var int : casa_te;
constraint forall(i in vecinos)(if asignacion_bebidas[i] == te then casa_te == i endif);

constraint casa_navarro == casa_te;


% andaluz en la primera casa de la izquierda
constraint asignacion_nacionalidad[1] == andaluz;


% el de la casa verde bebe cafe
%constraint forall(i in vecinos)(if asignacion_colores[i] == verde then asignacion_bebidas[i] == cafe endif);
var int : casa_verde;
constraint forall(i in vecinos)(if asignacion_colores[i] == verde then casa_verde == i endif);

var int : casa_cafe;
constraint forall(i in vecinos)(if asignacion_bebidas[i] == cafe then casa_cafe == i endif);

constraint casa_verde == casa_cafe;


% la casa verde esta al lado de la blanca y a su derecha (si i == 5, no hay casa a la derecha)
%constraint exists(x in vecinos)(if asignacion_colores[i] == blanco then asignacion_colores[i+1] == verde endif);
%constraint exists(x in vecinos)(asignacion_colores[x] == blanco /\ (if x != 5 then asignacion_colores[x+1] == verde endif));

var int : casa_blanca;
constraint forall(i in vecinos)(if asignacion_colores[i] == blanco then casa_blanca == i endif);

constraint casa_verde == casa_blanca+1;

% el escultor cria caracoles
%constraint forall(i in vecinos)(if asignacion_profesiones[i] == escultor then asignacion_animales[i] == caracoles endif);
var int : casa_escultor;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == escultor then casa_escultor == i endif);

var int : casa_caracoles;
constraint forall(i in vecinos)(if asignacion_animales[i] == caracoles then casa_caracoles == i endif);

constraint casa_escultor == casa_caracoles;


% el diplomatico vive en la casa amarilla
%constraint forall(i in vecinos)(if asignacion_profesiones[i] == diplomatico then asignacion_colores[i] == amarillo endif);
var int : casa_diplomatico;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == diplomatico then casa_diplomatico == i endif);

var int : casa_amarilla;
constraint forall(i in vecinos)(if asignacion_colores[i] == amarillo then casa_amarilla == i endif);

constraint casa_diplomatico == casa_amarilla;

% en la casa central se bebe leche
constraint asignacion_bebidas[3] == leche;


% andaluz en la primera casa de la izquierda, la de al lado es la azul, y el andaluz solo tiene una contigua
constraint asignacion_colores[2] == azul;



% el violinista bebe zumo
%constraint forall(i in vecinos)(if asignacion_profesiones[i] == violinista then asignacion_bebidas[i] == zumo endif);
var int : casa_violinista;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == violinista then casa_violinista == i endif);

var int : casa_zumo;
constraint forall(i in vecinos)(if asignacion_bebidas[i] == zumo then casa_zumo == i endif);

constraint casa_zumo == casa_violinista;



% al lado de la casa del zorro esta la casa del medico
%constraint forall(i in vecinos)(if asignacion_animales[i] == zorro then asignacion_profesiones[i+1] == medico \/ asignacion_profesiones[i-1] == medico endif);
var int : casa_zorro;
constraint forall(i in vecinos)(if asignacion_animales[i] == zorro then casa_zorro == i endif);

var int : casa_medico;
constraint forall(i in vecinos)(if asignacion_profesiones[i] == medico then casa_medico == i endif);


constraint casa_zorro != casa_medico /\ abs(casa_zorro - casa_medico) == 1;



% al lado de la casa del caballo esta la casa del diplomatico
var int : casa_caballo;
constraint forall(i in vecinos)(if asignacion_animales[i] == caballo then casa_caballo == i endif);

%var int : casa_diplomatico;
%constraint forall(i in vecinos)(if asignacion_profesiones[i] == diplomatico then casa_diplomatico == i endif);


constraint casa_caballo != casa_diplomatico  /\ abs(casa_caballo - casa_diplomatico) == 1;


constraint alldifferent(asignacion_nacionalidad);
constraint alldifferent(asignacion_colores);
constraint alldifferent(asignacion_animales);
constraint alldifferent(asignacion_profesiones);
constraint alldifferent(asignacion_bebidas);


% sacamos los resultados
var int : num_casa_agua;
var int : num_casa_cebra;

constraint forall(i in vecinos)(if asignacion_animales[i] == cebra then num_casa_cebra == i endif);
constraint forall(i in vecinos)(if asignacion_bebidas[i] == agua then num_casa_agua == i endif);

output ["Nacionalidades: \([asignacion_nacionalidad[i] | i in 1..5]) \n" ];
output ["Bebidas       : \([asignacion_bebidas[i] | i in 1..5]) \n" ];
output ["Profesion     : \([asignacion_profesiones[i] | i in 1..5]) \n" ];
output ["Mascota       : \([asignacion_animales[i] | i in 1..5]) \n" ];
output ["Color de casa : \([asignacion_colores[i] | i in 1..5]) \n\n" ];


output ["La cebra esta en la casa \(num_casa_cebra), donde vive el \(asignacion_nacionalidad[num_casa_cebra]), que bebe \(asignacion_bebidas[num_casa_cebra]), trabaja en \(asignacion_profesiones[num_casa_cebra]) y tiene la casa pintada de \(asignacion_colores[num_casa_cebra]) \n"];
output ["La persona que bebe agua vive en la casa \(num_casa_agua), es \(asignacion_nacionalidad[num_casa_agua]), tiene como mascota \(asignacion_animales[num_casa_agua]), trabaja en \(asignacion_profesiones[num_casa_agua]) y tiene la casa pintada de \(asignacion_colores[num_casa_agua]) \n"];


solve satisfy;