
(define (problem ejercicio6)

	(:domain ejercicio_6)

	(:objects
		; mapa 5 x 5
		l1_1 l1_2 l1_3 l1_4 l1_5 l2_1 l2_2 l2_3 l2_4 l2_5 l3_1 l3_2 l3_3 l3_4 l3_5 l4_1 l4_2 l4_3 l4_4 l4_5 l5_1 l5_2 l5_3 l5_4 l5_5 - localizacion

		; edificios y unidades del problema
		centroMando1 centroMando2 barracones1 extractor1 extractor2 bahia1 deposito1 - edificio
		vce1 vce2 vce3 vce4 vce5 - unidad
		marine1 marine2 segador1 - unidad
		impulsorSegador1 - investigacion
	)

	(:init
		; conexiones del grid 5 x 5
		(caminoEntre l1_1 l2_1)
		(caminoEntre l1_1 l1_2)
		(caminoEntre l1_2 l2_2)
		(caminoEntre l1_2 l1_3)
		(caminoEntre l1_2 l1_1)
		(caminoEntre l1_3 l2_3)
		(caminoEntre l1_3 l1_4)
		(caminoEntre l1_3 l1_2)
		(caminoEntre l1_4 l2_4)
		(caminoEntre l1_4 l1_5)
		(caminoEntre l1_4 l1_3)
		(caminoEntre l1_5 l2_5)
		(caminoEntre l1_5 l1_4)
		(caminoEntre l2_1 l1_1)
		(caminoEntre l2_1 l3_1)
		(caminoEntre l2_1 l2_2)
		(caminoEntre l2_2 l1_2)
		(caminoEntre l2_2 l3_2)
		(caminoEntre l2_2 l2_3)
		(caminoEntre l2_2 l2_1)
		(caminoEntre l2_3 l1_3)
		(caminoEntre l2_3 l3_3)
		(caminoEntre l2_3 l2_4)
		(caminoEntre l2_3 l2_2)
		(caminoEntre l2_4 l1_4)
		(caminoEntre l2_4 l3_4)
		(caminoEntre l2_4 l2_5)
		(caminoEntre l2_4 l2_3)
		(caminoEntre l2_5 l1_5)
		(caminoEntre l2_5 l3_5)
		(caminoEntre l2_5 l2_4)
		(caminoEntre l3_1 l2_1)
		(caminoEntre l3_1 l4_1)
		(caminoEntre l3_1 l3_2)
		(caminoEntre l3_2 l2_2)
		(caminoEntre l3_2 l4_2)
		(caminoEntre l3_2 l3_3)
		(caminoEntre l3_2 l3_1)
		(caminoEntre l3_3 l2_3)
		(caminoEntre l3_3 l4_3)
		(caminoEntre l3_3 l3_4)
		(caminoEntre l3_3 l3_2)
		(caminoEntre l3_4 l2_4)
		(caminoEntre l3_4 l4_4)
		(caminoEntre l3_4 l3_5)
		(caminoEntre l3_4 l3_3)
		(caminoEntre l3_5 l2_5)
		(caminoEntre l3_5 l4_5)
		(caminoEntre l3_5 l3_4)
		(caminoEntre l4_1 l3_1)
		(caminoEntre l4_1 l5_1)
		(caminoEntre l4_1 l4_2)
		(caminoEntre l4_2 l3_2)
		(caminoEntre l4_2 l5_2)
		(caminoEntre l4_2 l4_3)
		(caminoEntre l4_2 l4_1)
		(caminoEntre l4_3 l3_3)
		(caminoEntre l4_3 l5_3)
		(caminoEntre l4_3 l4_4)
		(caminoEntre l4_3 l4_2)
		(caminoEntre l4_4 l3_4)
		(caminoEntre l4_4 l5_4)
		(caminoEntre l4_4 l4_5)
		(caminoEntre l4_4 l4_3)
		(caminoEntre l4_5 l3_5)
		(caminoEntre l4_5 l5_5)
		(caminoEntre l4_5 l4_4)
		(caminoEntre l5_1 l4_1)
		(caminoEntre l5_1 l5_2)
		(caminoEntre l5_2 l4_2)
		(caminoEntre l5_2 l5_3)
		(caminoEntre l5_2 l5_1)
		(caminoEntre l5_3 l4_3)
		(caminoEntre l5_3 l5_4)
		(caminoEntre l5_3 l5_2)
		(caminoEntre l5_4 l4_4)
		(caminoEntre l5_4 l5_5)
		(caminoEntre l5_4 l5_3)
		(caminoEntre l5_5 l4_5)
		(caminoEntre l5_5 l5_4)

		; ahora solo se encuentran disponibles al inicio el centro
		; de mando y un VCE
		(entidadEnLocalizacion centroMando1 l1_1)
		(entidadEnLocalizacion vce1 l1_1)

		(unidadLibre vce1)

		; establecemos que recursos necesitan cada cosa
		; ahora con los valores de las funciones
		(= (necesitaRecurso CentroDeMando Mineral) 150)
		(= (necesitaRecurso CentroDeMando Gas) 50)
		(= (necesitaRecurso Barracones Mineral) 150)
		(= (necesitaRecurso Barracones Gas) 0)
		(= (necesitaRecurso Extractor Mineral) 75)
		(= (necesitaRecurso Extractor Gas) 0)
		(= (necesitaRecurso BahiaIngenieria Mineral) 125)
		(= (necesitaRecurso BahiaIngenieria Gas) 0)
		(= (necesitaRecurso Deposito Mineral) 75)
		(= (necesitaRecurso Deposito Gas) 25)

		(= (necesitaRecurso VCE Mineral) 50)
		(= (necesitaRecurso VCE Gas) 0)
		(= (necesitaRecurso Marine Mineral) 50)
		(= (necesitaRecurso Marine Gas) 0)
		(= (necesitaRecurso Segador Mineral) 50)
		(= (necesitaRecurso Segador Gas) 50)

		(= (necesitaRecurso ImpulsorSegador Mineral) 50)
		(= (necesitaRecurso ImpulsorSegador Gas) 200)


		; establecemos que tipos de edificios son
		(esEdificio barracones1 Barracones)
		(esEdificio centroMando1 CentroDeMando)
		(esEdificio centroMando2 CentroDeMando)
		(esEdificio extractor1 Extractor)
		(esEdificio extractor2 Extractor)
		(esEdificio bahia1 BahiaIngenieria)
		(esEdificio deposito1 Deposito)

		; establecemos que tipo de unidades son
		(esUnidad vce1 VCE)
		(esUnidad vce2 VCE)
		(esUnidad vce3 VCE)
		(esUnidad vce4 VCE)
		(esUnidad vce5 VCE)

		(esUnidad marine1 Marine)
		(esUnidad marine2 Marine)
		(esUnidad segador1 Segador)

		(esInvestigacion impulsorSegador1 ImpulsorSegador)

		; asignamos los recursos a localizaciones
		(asignarNodoRecursoLocalizacion Mineral l2_2)
		(asignarNodoRecursoLocalizacion Mineral l5_1)
		(asignarNodoRecursoLocalizacion Mineral l3_4)

		(asignarNodoRecursoLocalizacion Gas l5_3)
		(asignarNodoRecursoLocalizacion Gas l4_4)


		; comenzamos con 0 recursos almacenados
		; y un tope de almacen de 100
		(= (recursoAlmacenado Gas) 0)
		(= (recursoAlmacenado Mineral) 0)
		(= (topeRecurso Gas) 100)
		(= (topeRecurso Mineral) 100)

		(= (unidadesExtrayendo Mineral) 0)
		(= (unidadesExtrayendo Gas) 0)


		; el tiempo transcurrido al inicio es 0
		(= (tiempoTrascurrido) 0)

		; los tiempos necesarios para cada cosa
		(= (tiempoNecesario CentroDeMando) 100)
		(= (tiempoNecesario Barracones) 46)
		(= (tiempoNecesario Extractor) 21)
		(= (tiempoNecesario BahiaIngenieria) 25)
		(= (tiempoNecesario Deposito) 21)
		(= (tiempoNecesario VCE) 12)
		(= (tiempoNecesario Marine) 18)
		(= (tiempoNecesario Segador) 32)
		(= (tiempoNecesario ImpulsorSegador) 120)

		(= (tiempoRecolectar) 10)
		(= (distanciaLocalizaciones) 15)

		; la velocidad de cada unidad
		; como dice el enunciado, el segador es el doble de rapido que el marine
		(= (velocidad VCE) 1.5)
		(= (velocidad Marine) 1)
		(= (velocidad Segador) 0.5)
	)

	(:goal
		(and
			; la meta es tener dos marines y un segador
			(entidadEnLocalizacion marine1 l5_5)
			(entidadEnLocalizacion marine2 l2_2)
			(entidadEnLocalizacion segador1 l2_2)
		)
	)
	; para este ejercicio minimizamos el tiempo transcurrido
	(:metric minimize (tiempoTrascurrido))
)
