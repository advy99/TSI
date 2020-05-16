(define (domain ejercicio_6)
	(:requirements :strips :adl :fluents)

	(:types
		entidad localizacion - object
		unidad - entidad
		edificio - entidad
		investigacion - entidad
		recurso - object
		tipoEdificio - edificio
		tipoUnidad - unidad
		tipoRecurso - recurso
		tipoInvestigacion - investigacion
	)

	(:constants
		VCE - tipoUnidad
		Marine - tipoUnidad
		Segador - tipoUnidad

		CentroDeMando - tipoEdificio
		Barracones - tipoEdificio
		Extractor - tipoEdificio
		BahiaIngenieria - tipoEdificio
		Deposito - tipoEdificio

		Mineral - tipoRecurso
		Gas - tipoRecurso

		ImpulsorSegador - tipoInvestigacion

	)

	(:predicates
		(entidadEnLocalizacion ?obj - entidad ?x - localizacion)
		(caminoEntre ?x1 - localizacion ?x2 - localizacion)
		(asignarNodoRecursoLocalizacion ?r - recurso ?x - localizacion)
		(estaExtrayendoRecurso ?rec - recurso ?loc - localizacion)
		; cambiamos edificio por entidad
		(necesitaRecurso ?x - entidad ?rec - recurso)

		(unidadLibre ?uni - unidad)

		(esEdificio ?edif - edificio ?tipoEdif - tipoEdificio)
		(esUnidad ?unid - unidad ?tUnid - tipoUnidad)
		(esInvestigacion ?inves - investigacion ?tInves - tipoInvestigacion )
		(heInvestigado ?invest - investigacion)
	)

	(:functions
		(necesitaRecurso ?x - entidad ?rec - recurso)
		(recursoAlmacenado ?tipoRecurso - tipoRecurso )
		(topeRecurso ?tipoRecurso - tipoRecurso)
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
	  :parameters (?x - unidad ?rec - recurso ?loc - localizacion ?edi - edificio)
	  :precondition
	  		(and
				(entidadEnLocalizacion ?x ?loc)
				(asignarNodoRecursoLocalizacion ?rec ?loc)
				(unidadLibre ?x)
				(esUnidad ?x VCE)
				(imply (asignarNodoRecursoLocalizacion Gas ?loc) (and (entidadEnLocalizacion ?edi ?loc) (esEdificio ?edi Extractor) ) )
			)

	  :effect
	  		(and
				(not (unidadLibre ?x))
				(estaExtrayendoRecurso ?rec ?loc)
			)
	)

	(:action construir
	  :parameters (?unidad - unidad ?x - localizacion ?edificio - edificio)
	  :precondition
	  		(and
				(unidadLibre ?unidad)
				(entidadEnLocalizacion ?unidad ?x)
				(esUnidad ?unidad VCE)
				(not (exists (?edif - edificio) (entidadEnLocalizacion ?edif ?x) ) )

				(forall (?r - tipoRecurso)
					(exists (?t - tipoEdificio)
						(and
							(esEdificio ?edificio ?t)
							(>=
								(recursoAlmacenado ?r)
								(necesitaRecurso ?t ?r)
							)
						)
					)
				)

			)

	  :effect
	  		(and
				(entidadEnLocalizacion ?edificio ?x)
				(forall (?r - tipoRecurso)
					(exists (?t - tipoEdificio)
						(and
							(esEdificio ?edificio ?t)
							(decrease
								(recursoAlmacenado ?r)
								(necesitaRecurso ?t ?r)
							)
						)
					)
				)

				(when (esEdificio ?edificio Deposito)
					(increase (topeRecurso Gas) 100)
					(increase (topeRecurso Mineral) 100)
				)
			)
	)

	(:action reclutar
		:parameters (?unid - unidad ?edificio - edificio ?loc - localizacion)
		:precondition
			(and
				(not (exists (?l - localizacion) (and  (entidadEnLocalizacion ?unid ?l)) ) )
				(imply (or (esUnidad ?unid VCE) (esUnidad ?unid Marine) ) (estaExtrayendoRecurso Mineral) )
				(imply
					(esUnidad ?unid Segador)
					(and
						(estaExtrayendoRecurso Mineral)
						(estaExtrayendoRecurso Gas)
						(exists (?t - investigacion) (and (heInvestigado ?t) (esInvestigacion ?t ImpulsorSegador)) )

					)
				)

				(entidadEnLocalizacion ?edificio ?loc)

				(imply (esEdificio ?edificio CentroDeMando) (esUnidad ?unid VCE))
				(imply (esEdificio ?edificio Barracones) (or  (esUnidad ?unid Marine) (esUnidad ?unid Segador) ) )
			)

		:effect
			( and
				(entidadEnLocalizacion ?unid ?loc)
				(unidadLibre ?unid)
			)

	)


	(:action investigar
		:parameters (?inves - investigacion ?edif - edificio)

		:precondition
			(and
				(esEdificio ?edif BahiaIngenieria)
				(exists (?l - localizacion) (entidadEnLocalizacion ?edif ?l) )
				(not (heInvestigado ?inves))
				(forall (?r - tipoRecurso)
					(exists (?t - tipoInvestigacion)
						(and
							(esInvestigacion ?inves ?t)
							(>=
								(recursoAlmacenado ?r)
								(necesitaRecurso ?t ?t)
							)
							;(imply (!= (necesitaRecurso ?t ?r) 0) (estaExtrayendoRecurso ?r) )
						)
					)
				)
			)

		:effect
			(and
				(heInvestigado ?inves)
			)
			(forall (?r - tipoRecurso)
				(exists (?t - tipoInvestigacion)
					(and
						(esInvestigacion ?inves ?t)
						(decrease
							(recursoAlmacenado ?r)
							(necesitaRecurso ?t ?t)
						)
						;(imply (!= (necesitaRecurso ?t ?r) 0) (estaExtrayendoRecurso ?r) )
					)
				)
			)
	)

	(:action recolectar
		:parameters (?recurso - tipoRecurso)
		:precondition
			(
				(estaExtrayendoRecurso ?recurso)

			)

		:effect
			(
				(forall (?l - localizacion)
					(when

					)

				)
			)
	)

)
