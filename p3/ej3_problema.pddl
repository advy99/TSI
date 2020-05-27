
(define (problem ejercicio3)

	(:domain ejercicio_3)

	(:objects
		; mapa 5 x 5
		l1_1 l1_2 l1_3 l1_4 l1_5 l2_1 l2_2 l2_3 l2_4 l2_5 l3_1 l3_2 l3_3 l3_4 l3_5 l4_1 l4_2 l4_3 l4_4 l4_5 l5_1 l5_2 l5_3 l5_4 l5_5 - localizacion
		; edificios y unidades (hay de mas para pruebas)
		centroMando1 centroMando2 barracones1 extractor1 - edificio
		vce1 vce2 vce3 - unidad
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


		; posiciones de las entidades
		; los barracones y extractor están sin construir
		(entidadEnLocalizacion centroMando1 l1_1)
		(entidadEnLocalizacion vce1 l1_1)
		(entidadEnLocalizacion vce2 l1_1)
		(entidadEnLocalizacion vce3 l1_1)
		(unidadLibre vce1)
		(unidadLibre vce2)
		(unidadLibre vce3)

		; recurso que necesitan cada edificio
		; ahora el centro de mando necesita más
		(necesitaRecurso Barracones Mineral)
		(necesitaRecurso CentroDeMando Gas)
		(necesitaRecurso CentroDeMando Mineral)
		(necesitaRecurso Extractor Mineral)

		; tipos de edificios
		(esEdificio barracones1 Barracones)
		(esEdificio centroMando1 CentroDeMando)
		(esEdificio centroMando2 CentroDeMando)
		(esEdificio extractor1 Extractor)

		; tipos de unidades
		(esUnidad vce1 VCE)
		(esUnidad vce2 VCE)
		(esUnidad vce3 VCE)

		; establecemos en que localizacinoes están los recursos
		(asignarNodoRecursoLocalizacion Mineral l2_2)
		(asignarNodoRecursoLocalizacion Mineral l5_1)
		(asignarNodoRecursoLocalizacion Mineral l3_4)

		(asignarNodoRecursoLocalizacion Gas l5_3)
		(asignarNodoRecursoLocalizacion Gas l4_4)

	)

	(:goal
		(and
			; para pruebas de que funciona intentamos construir
			; un segundo centro de mando
			;(entidadEnLocalizacion centroMando2 l5_5)

			; el objetivo es construir los barracones
			(entidadEnLocalizacion barracones1 l3_2)
		)
	)
)
