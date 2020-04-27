include "globals.mzn";


% definimos las letras con su valor en el array, es decir, por ejemplo la E será la posición 0 en el array
int : E = 0;
int : T = 1;
int : N = 2;
int : S = 3;
int : I = 4;
int : F = 5;
int : A = 6;
int : D = 7;
int : R = 8;
int : K = 9;

% definimos el array donde estaran las letras
array[0..9] of var 0..9: letras;

% definimos las variables para gestionar el acarreo
var int : acarreo; var int : acarreo2; var int : acarreo3; var int : acarreo4; var int : acarreo5;

% usando globals.mzn nos aseguramos que todos los valores de las letras serán disintos
constraint alldifferent(letras);

% aplicamos las operaciones que nos piden, haciendo modulo 10 para que esten
% entre 0..9, y calculamos el accareo para la siguiente operacion
constraint (letras[E] + letras[E] + letras[E]) mod 10 == letras[E];
acarreo = (letras[E] + letras[E] + letras[E]) div 10;

constraint (letras[T] + letras[T] + letras[N] + acarreo) mod 10 == letras[T];
acarreo2 = (letras[T] + letras[T] + letras[N] + acarreo) div 10;

constraint (letras[S] + letras[S] + letras[I] + acarreo2) mod 10 == letras[F];
acarreo3 = (letras[S] + letras[S] + letras[I] + acarreo2) div 10;


constraint (letras[E] + letras[E] + letras[E] + acarreo3) mod 10 == letras[A];
acarreo4 = (letras[E] + letras[E] + letras[E] + acarreo3) div 10;

constraint (letras[T] + letras[F] + letras[D] + acarreo4) mod 10 == letras[R];
acarreo5 = (letras[T] + letras[F] + letras[D] + acarreo4) div 10;

% K se corresponde al acarreo de la última operacion
constraint letras[K] == acarreo5;

% sacamos por pantalla la solución
output ["Solución: \n"];
output ["\t E: \(letras[E])\n"];
output ["\t T: \(letras[T])\n"];
output ["\t N: \(letras[N])\n"];
output ["\t S: \(letras[S])\n"];
output ["\t I: \(letras[I])\n"];
output ["\t F: \(letras[F])\n"];
output ["\t A: \(letras[A])\n"];
output ["\t D: \(letras[D])\n"];
output ["\t R: \(letras[R])\n"];
output ["\t K: \(letras[K])\n\n"];


output ["\t\t   TESTE \t\t   \(letras[T])\(letras[E])\(letras[S])\(letras[T])\(letras[E])\n"];
output ["\t\t + FESTE \t\t + \(letras[F])\(letras[E])\(letras[S])\(letras[T])\(letras[E])\n"];
output ["\t\t + DEINE \t\t + \(letras[D])\(letras[E])\(letras[I])\(letras[N])\(letras[E])\n"];
output ["\t\t======== \t\t ========\n"];
output ["\t\t  KRAFTE \t\t  \(letras[K])\(letras[R])\(letras[A])\(letras[F])\(letras[T])\(letras[E])\n"];



solve satisfy;
