(define (domain ejercicio_1)
	(:requirements :strips :adl :fluents)

	(:types
		; tenemos los tipos explicados
		entidad localizacion - object
		; tanto los edificios como las unidades serán entidades
		; para hacer más facil el comprobar que está en cada sitio, etc
		unidad - entidad
		edificio - entidad
		recurso - object
		; tipos para las constantes, derivados de los originales
		; al ser una especialización
		tipoEdificio - edificio
		tipoUnidad - unidad
		tipoRecurso - recurso
	)

	(:constants
		; constantes para evitar tener que estar declarando
		; muchos objetos
		VCE - tipoUnidad
		CentroDeMando - tipoEdificio
		Barracones - tipoEdificio
		Mineral - tipoRecurso
		Gas - tipoRecurso

	)

	(:predicates
		;predicados:

		; para comprobar si una entidad (ya sea edificio o unidad)
		; está en una localización
		(entidadEnLocalizacion ?obj - entidad ?x - localizacion)

		; para comprobar que dos localizaciones están conectadas
		; en el problema declaramos la forma de como está conectada
		; en principio mapa cuadriculado sin diagonales
		(caminoEntre ?x1 - localizacion ?x2 - localizacion)

		; para comprobar si en una localizacion hay un recurso
		(asignarNodoRecursoLocalizacion ?r - recurso ?x - localizacion)

		; para saber si se está extrayendo un recurso
		(estaExtrayendoRecurso ?rec - recurso)

		; para saber que recurso necesita cada edificio
		(necesitaRecurso ?x - tipoEdificio ?rec - tipoRecurso)

		; para comprobar si una unidad está libre
		(unidadLibre ?uni - unidad)

		; para comprobar si un edificio y una unidad es de cierto tipo
		(esEdificio ?edif - edificio ?tipoEdif - tipoEdificio)
		(esUnidad ?unid - unidad ?tUnid - tipoUnidad)
	)

	; acción navegar
	(:action navegar
		; como parametro la unidad, y dos localizaciones, la actual y la nueva
	  :parameters (?unidad - unidad ?x ?y - localizacion)
	  :precondition
	  		(and
				; como precondicion, tiene que estar en la primera localizacion
				(entidadEnLocalizacion ?unidad ?x)
				; las localizaciones tienen que estar conectadas
				(caminoEntre ?x ?y)
				; la unidad tiene que estar libre (no extrayendo recursos)
				(unidadLibre ?unidad)
			)

	  :effect
	  		(and
				; como efecto, pasa a estar en la nueva localizacion
				(entidadEnLocalizacion ?unidad ?y)
				; y dejar de estar en la antigua
				(not (entidadEnLocalizacion ?unidad ?x))
			)
	)

	(:action asignar
		; accion para asignar una unidad a extraer un recurso en una localizacion
	  :parameters (?x - unidad ?rec - recurso ?loc - localizacion)
	  :precondition
	  		(and
				; la unidad tiene que estar en esa localizacion
				(entidadEnLocalizacion ?x ?loc)

				; en dicha localizacion tiene que estar ese recurso
				(asignarNodoRecursoLocalizacion ?rec ?loc)

				; la unidad tiene que estar libre
				(unidadLibre ?x)
			)
	  :effect
	  		(and
				; una vez se asigna la unidad no esta libre
				(not (unidadLibre ?x))
				; ahora se está extrayendo el recurso
				(estaExtrayendoRecurso ?rec)

			)
	)

	(:action construir
		; acción para construir un edificio - para este ejercicio solo se necesita un recurso
	  :parameters (?unidad - unidad ?x - localizacion ?edificio - edificio ?recurso - recurso)
	  :precondition
	  		(and
				; tiene que ser una unidad libre
				(unidadLibre ?unidad)

				; tiene que estar en la localizacion a construir el edificio
				(entidadEnLocalizacion ?unidad ?x)

				; no hay otro edificio en esa localizacion
				(not (exists (?edif - edificio) (entidadEnLocalizacion ?edif ?x) ) )

				; existe un tipo de edificio que es el que vamos a construir
				; necesita el recurso dado, y ese recurso se está extrayendo
				(exists (?t - tipoEdificio)
					(and
						(esEdificio ?edificio ?t)
						(necesitaRecurso ?t ?recurso)
						(estaExtrayendoRecurso ?recurso)
					)
				)

			)
	  :effect
	  		(and
				; como efecto, se construye el edificio
				(entidadEnLocalizacion ?edificio ?x)
			)
	)

)
