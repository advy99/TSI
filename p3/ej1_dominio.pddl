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
		Mineral - tipoRecurso
		Gas - tipoRecurso

	)

	(:predicates
		(entidadEnLocalizacion ?obj - entidad ?x - localizacion)
		(caminoEntre ?x1 - localizacion ?x2 - localizacion)
		(asignarNodoRecursoLocalizacion ?r - recurso ?x - localizacion)
		(estaExtrayendoRecurso ?rec - recurso)
		(necesitaRecurso ?x - tipoEdificio ?rec - tipoRecurso)

		(unidadLibre ?uni - unidad)

		(esEdificio ?edif - edificio ?tipoEdif - tipoEdificio)
		(esUnidad ?unid - unidad ?tUnid - tipoUnidad)
	)

	(:action navegar
	  :parameters (?unidad - unidad ?x ?y - localizacion)
	  :precondition
	  		(and
				(entidadEnLocalizacion ?unidad ?x)
				(caminoEntre ?x ?y)
				(unidadLibre ?unidad)
			)

	  :effect
	  		(and
				(entidadEnLocalizacion ?unidad ?y)
				(not (entidadEnLocalizacion ?unidad ?x))
			)
	)

	(:action asignar
	  :parameters (?x - unidad ?rec - recurso ?loc - localizacion)
	  :precondition
	  		(and
				(entidadEnLocalizacion ?x ?loc)
				(asignarNodoRecursoLocalizacion ?rec ?loc)
				(unidadLibre ?x)
			)
	  :effect
	  		(and
				(not (unidadLibre ?x))
				(estaExtrayendoRecurso ?rec)

			)
	)

	(:action construir
	  :parameters (?unidad - unidad ?x - localizacion ?edificio - edificio ?recurso - recurso)
	  :precondition
	  		(and
				(unidadLibre ?unidad)
				(entidadEnLocalizacion ?unidad ?x)
				(not (exists (?edif - edificio) (entidadEnLocalizacion ?edif ?x) ) )

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
				(entidadEnLocalizacion ?edificio ?x)
			)
	)

)
