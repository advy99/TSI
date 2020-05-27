
(define (problem ejercicio4)

	(:domain ejercicio_4)

	(:objects
		; mapa 5 x 5
		l1_1 l1_2 l1_3 l1_4 l1_5 l2_1 l2_2 l2_3 l2_4 l2_5 l3_1 l3_2 l3_3 l3_4 l3_5 l4_1 l4_2 l4_3 l4_4 l4_5 l5_1 l5_2 l5_3 l5_4 l5_5 - localizacion

		; edificios y unidades a usar
		centroMando1 centroMando2 barracones1 extractor1 - edificio
		vce1 vce2 vce3 - unidad
		marine1 marine2 segador1 - unidad
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
		(necesitaRecurso Barracones Mineral)
		(necesitaRecurso CentroDeMando Gas)
		(necesitaRecurso CentroDeMando Mineral)
		(necesitaRecurso Extractor Mineral)

		(necesitaRecurso VCE Mineral)
		(necesitaRecurso Marine Mineral)
		(necesitaRecurso Segador Mineral)
		(necesitaRecurso Segador Gas)

		; establecemos que tipos de edificios son
		(esEdificio barracones1 Barracones)
		(esEdificio centroMando1 CentroDeMando)
		(esEdificio centroMando2 CentroDeMando)
		(esEdificio extractor1 Extractor)

		; establecemos que tipo de unidades son
		(esUnidad vce1 VCE)
		(esUnidad vce2 VCE)
		(esUnidad vce3 VCE)

		(esUnidad marine1 Marine)
		(esUnidad marine2 Marine)
		(esUnidad segador1 Segador)

		; asignamos los recursos a localizaciones
		(asignarNodoRecursoLocalizacion Mineral l2_2)
		(asignarNodoRecursoLocalizacion Mineral l5_1)
		(asignarNodoRecursoLocalizacion Mineral l3_4)

		(asignarNodoRecursoLocalizacion Gas l5_3)
		(asignarNodoRecursoLocalizacion Gas l4_4)

	)

	(:goal
		(and
			; la meta es tener dos marines y un segador
			(entidadEnLocalizacion marine1 l5_5)
			(entidadEnLocalizacion marine2 l2_2)
			(entidadEnLocalizacion segador1 l2_2)
		)
	)
)
