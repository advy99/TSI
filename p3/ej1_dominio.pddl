(define (domain ejercicio_1)
	(:requirements :strips :adl :fluents)

	(:types
		entidad localizacion - object
		unidad - entidad
		edificio - entidad
		recurso - object
		tipoEdificio - edificio
		tipoUnidad - unidad
		tipoRecurso - recurso
	)

	(:constants
		VCE - tipoUnidad
		CentroDeMando - tipoEdificio
		Barracones - tipoEdificio
		Minerales - tipoRecurso
		Gas - tipoRecurso
	)

	(:predicates
		(entidadEnLocalizacion ?obj - entidad ?x - localizacion)
		(caminoEntre ?x1 - localizacion ?x2 - localizacion)
		(asignarNodoRecursoLocalizacion ?r - recurso ?x - localizacion)
		(estaExtrayendoRecurso ?vce - unidad ?x - localizacion)
		(necesitaRecurso ?x - edificio ?recurso - recurso)

		(unidadLibre ?uni - unidad)

		(edificioEs ?edif - edificio ?tipoEdif - tipoEdificio)
		(unidadEs ?unid - unidad ?tUnid - tipoUnidad)
	)

	(:action navegar
	  :parameters (?unidad - unidad ?x ?y - localizacion)
	  :precondition
	  		(and
				(entidadEnLocalizacion ?unidad ?x)
				(caminoEntre ?x ?y)
			)

	  :effect
	  		(and
				(entidadEnLocalizacion ?unidad ?y)
				(not (entidadEnLocalizacion ?unidad ?x))
			)
	)

	(:action asignar
	  :parameters (?x - unidad ?nodo - recurso ?loc - localizacion)
	  :precondition
	  		(and
				(entidadEnLocalizacion ?x ?loc)
				(unidadLibre ?x)
				(asignarNodoRecursoLocalizacion ?nodo ?loc)
			)
	  :effect
	  		(and
				(not (unidadLibre ?x))
			)
	)

	(:action construir
	  :parameters (?unidad - unidad ?x - localizacion ?edificio - edificio ?recurso - recurso)
	  :precondition
	  		(and
				(unidadLibre ?unidad)
				(entidadEnLocalizacion ?unidad ?x)
				(necesitaRecurso ?edificio ?recurso)
			)
	  :effect
	  		(and
				(entidadEnLocalizacion ?edificio ?x)
			)
	)

)
