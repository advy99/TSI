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
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == vasco then asignacion_colores[i] == rojo endif);

% el catalan tiene un perro
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == catalan then asignacion_animales[i] == perro endif);

% el gallego es pintor
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == gallego then asignacion_profesiones[i] == pintor endif);

% el navarro bebe te
constraint forall(i in vecinos)(if asignacion_nacionalidad[i] == navarro then asignacion_bebidas[i] == te endif);

% andaluz en la primera casa de la izquierda
constraint asignacion_nacionalidad[1] == andaluz;

% el de la casa verde bebe cafe
constraint forall(i in vecinos)(if asignacion_colores[i] == verde then asignacion_bebidas[i] == cafe endif);

% la casa verde esta al lado de la blanca y a su derecha
constraint forall(i in vecinos)(if asignacion_colores[i] == verde then asignacion_colores[i-1] == blanco endif);

% el escultor cria caracoles
constraint forall(i in vecinos)(if asignacion_profesiones[i] == escultor then asignacion_animales[i] == caracoles endif);

% el diplomatico vive en la casa amarilla
constraint forall(i in vecinos)(if asignacion_profesiones[i] == diplomatico then asignacion_colores[i] == amarillo endif);

% en la casa central se bebe leche
constraint asignacion_bebidas[3] == leche;

% andaluz en la primera casa de la izquierda, la de al lado es la azul, y el andaluz solo tiene una contigua
constraint asignacion_colores[2] == azul;

% el diplomatico vive en la casa amarilla
constraint forall(i in vecinos)(if asignacion_profesiones[i] == violinista then asignacion_bebidas[i] == zumo endif);

% al lado de la casa del zorro esta la casa del medico
constraint forall(i in vecinos)(if asignacion_animales[i] == zorro then asignacion_profesiones[i+1] == medico \/ asignacion_profesiones[i-1] == medico endif);

% al lado de la casa del caballo esta la casa del diplomatico
constraint forall(i in vecinos)(if asignacion_animales[i] == caballo then asignacion_profesiones[i+1] == diplomatico \/ asignacion_profesiones[i-1] == diplomatico endif);


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

output ["La cebra esta en la casa \(num_casa_cebra), donde vive el \(asignacion_nacionalidad[num_casa_cebra]), que bebe \(asignacion_bebidas[num_casa_cebra]), trabaja en \(asignacion_profesiones[num_casa_cebra]) y tiene la casa pintada de \(asignacion_colores[num_casa_cebra]) \n"];
output ["La persona que bebe agua vive en la casa \(num_casa_agua), es \(asignacion_nacionalidad[num_casa_agua]), tiene como mascota \(asignacion_animales[num_casa_agua]), trabaja en \(asignacion_profesiones[num_casa_agua]) y tiene la casa pintada de \(asignacion_colores[num_casa_agua]) \n"];


solve satisfy;