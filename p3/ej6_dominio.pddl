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
		(estaExtrayendoRecurso ?rec - recurso)
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
		(unidadesExtrayendo ?tipoRecurso - tipoRecurso)
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
	  :parameters (?x - unidad ?rec - tipoRecurso ?loc - localizacion ?edi - edificio)
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
				(estaExtrayendoRecurso ?rec)
				(increase
					(unidadesExtrayendo ?rec)
					1
				)
			)
	)

	(:action desasignar
		:parameters (?unid - unidad ?loc - localizacion ?rec - tipoRecurso)
		:precondition
			(and
				(not (unidadLibre ?unid))
				(entidadEnLocalizacion ?unid ?loc)
				(asignarNodoRecursoLocalizacion ?rec ?loc)
			)

		:effect
			(and
				(unidadLibre ?unid)
				(decrease
					(unidadesExtrayendo ?rec)
					1
				)

				(when (and (not (> (unidadesExtrayendo ?rec) 0) ) )
					(and
						(not (estaExtrayendoRecurso ?rec))
					)
				)
			)

	)

	(:action construir
	  :parameters (?unidad - unidad ?x - localizacion ?edificio - edificio ?tEdif - tipoEdificio)
	  :precondition
	  		(and
				(unidadLibre ?unidad)
				(entidadEnLocalizacion ?unidad ?x)
				(esUnidad ?unidad VCE)
				(not (exists (?edif - edificio) (entidadEnLocalizacion ?edif ?x) ) )

				(forall (?r - tipoRecurso)
					(and
						(esEdificio ?edificio ?tEdif)
						(>=
							(topeRecurso ?r)
							(necesitaRecurso ?tEdif ?r)
						)
						(>=
							(recursoAlmacenado ?r)
							(necesitaRecurso ?tEdif ?r)
						)

					)
				)

			)

	  :effect
	  		(and
				(entidadEnLocalizacion ?edificio ?x)
				(decrease
					(recursoAlmacenado Mineral)
					(necesitaRecurso ?tEdif Mineral)
				)
				(decrease
					(recursoAlmacenado Gas)
					(necesitaRecurso ?tEdif Gas)
				)


				(when (and (esEdificio ?edificio Deposito) )
					(and
						(increase (topeRecurso Gas) 100)
						(increase (topeRecurso Mineral) 100)
					)
				)
			)
	)

	(:action reclutar
		:parameters (?unid - unidad ?tUnid - tipoUnidad ?edificio - edificio ?loc - localizacion)
		:precondition
			(and
				(esUnidad ?unid ?tUnid)
				(not (exists (?l - localizacion) (and  (entidadEnLocalizacion ?unid ?l)) ) )

				(forall (?tRes - tipoRecurso)
					(and
						(>=
							(topeRecurso ?tRes)
							(necesitaRecurso ?tUnid ?tRes)
						)
						(>=
							(recursoAlmacenado ?tRes)
							(necesitaRecurso ?tUnid ?tRes)
						)
					)
				)

				(imply
					(esUnidad ?unid Segador)
					(and
						(exists (?t - investigacion) (and (heInvestigado ?t) (esInvestigacion ?t ImpulsorSegador)) )
					)
				)

				(entidadEnLocalizacion ?edificio ?loc)

				(imply (esUnidad ?unid VCE) (esEdificio ?edificio CentroDeMando) )
				(imply (or  (esUnidad ?unid Marine) (esUnidad ?unid Segador) ) (esEdificio ?edificio Barracones) )
			)

		:effect
			( and
				(entidadEnLocalizacion ?unid ?loc)
				(unidadLibre ?unid)
				(decrease
					(recursoAlmacenado Mineral)
					(necesitaRecurso ?tUnid Mineral)
				)
				(decrease
					(recursoAlmacenado Gas)
					(necesitaRecurso ?tUnid Gas)
				)
			)

	)


	(:action investigar
		:parameters (?inves - investigacion ?edif - edificio ?tInves - tipoInvestigacion)

		:precondition
			(and
				(esInvestigacion ?inves ?tInves)
				(esEdificio ?edif BahiaIngenieria)
				(exists (?l - localizacion) (entidadEnLocalizacion ?edif ?l) )
				(not (heInvestigado ?inves))
				(forall (?r - tipoRecurso)
					(and

						(>=
							(recursoAlmacenado ?r)
							(necesitaRecurso ?tInves ?r)
						)
						(>=
							(topeRecurso ?r)
							(necesitaRecurso ?tInves ?r)
						)
					)
				)
			)

		:effect
			(and
				(heInvestigado ?inves)
				(decrease
					(recursoAlmacenado Mineral)
					(necesitaRecurso ?tInves Mineral)
				)
				(decrease
					(recursoAlmacenado Gas)
					(necesitaRecurso ?tInves Gas)
				)
			)

	)

	(:action recolectar
		:parameters (?rec - tipoRecurso)
		:precondition
			(and
				(estaExtrayendoRecurso ?rec)
				(<
					(recursoAlmacenado ?rec)
					(topeRecurso ?rec)
				)

			)


		:effect
			(and
				(increase
					(recursoAlmacenado ?rec)
					(*
						25
						(unidadesExtrayendo ?rec)
					)
				)
			)
	)

)
