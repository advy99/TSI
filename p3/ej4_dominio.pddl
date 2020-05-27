(define (domain ejercicio_4)
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
		; ahora tenemos más
		Marine - tipoUnidad
		Segador - tipoUnidad

		CentroDeMando - tipoEdificio
		Barracones - tipoEdificio
		Extractor - tipoEdificio

		Mineral - tipoRecurso
		Gas - tipoRecurso

	)

	(:predicates
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

		; para saber que recurso necesita cada entidad
		; cambiamos edificio por entidad ya que las unidades necesitaran recursos
		(necesitaRecurso ?x - entidad ?rec - tipoRecurso)

		; para comprobar si una unidad está libre
		(unidadLibre ?uni - unidad)

		; para comprobar si un edificio y una unidad es de cierto tipo
		(esEdificio ?edif - edificio ?tipoEdif - tipoEdificio)
		(esUnidad ?unid - unidad ?tUnid - tipoUnidad)
	)

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
	  :parameters (?x - unidad ?rec - recurso ?loc - localizacion ?edi - edificio)
	  :precondition
	  		(and
				; la unidad tiene que estar en esa localizacion
				(entidadEnLocalizacion ?x ?loc)

				; en dicha localizacion tiene que estar ese recurso
				(asignarNodoRecursoLocalizacion ?rec ?loc)

				; la unidad tiene que estar libre
				(unidadLibre ?x)

				; ahora que tenemos más unidades, solo los VCE pueden extraer
				(esUnidad ?x VCE)

				; si no es Gas podemos extraer, si es Gas tenemos un edificio de tipo Extractor en la localizacion
				(imply (asignarNodoRecursoLocalizacion Gas ?loc) (and (entidadEnLocalizacion ?edi ?loc) (esEdificio ?edi Extractor) ) )
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
		; acción para construir un edificio - para este ejercicio pueden necesitar varios recursos
	  :parameters (?unidad - unidad ?x - localizacion ?edificio - edificio)
	  :precondition
	  		(and
				; tiene que ser una unidad libre
				(unidadLibre ?unidad)

				; tiene que estar en la localizacion a construir el edificio
				(entidadEnLocalizacion ?unidad ?x)

				; ahora que teneomos más unidades, solo los VCE pueden construir
				(esUnidad ?unidad VCE)

				; no hay otro edificio en esa localizacion
				(not (exists (?edif - edificio) (entidadEnLocalizacion ?edif ?x) ) )

				; para todos los posibles recursos
				(forall (?r - tipoRecurso)
					; existe un tipo de edificio
					(exists (?t - tipoEdificio)
						(and
							; que es el que vamos a construir
							(esEdificio ?edificio ?t)
							; si ese edificio necesita el recurso, se tiene que estar extrayendo
							(imply (necesitaRecurso ?t ?r) (estaExtrayendoRecurso ?r) )
						)
					)
				)

			)

	  :effect
	  		(and
				; como efecto, se construye el edificio
				(entidadEnLocalizacion ?edificio ?x)
			)
	)

	(:action reclutar
		; accion para reclutar unidades, necesitamos la unidad y el edificio y localizacion
		; donde se va a construir
		:parameters (?unid - unidad ?edificio - edificio ?loc - localizacion)
		:precondition
			(and
				; para reclutar la unidad dicha unidad no puede estar en ninguna localizacion
				(not (exists (?l - localizacion) (and  (entidadEnLocalizacion ?unid ?l)) ) )

				; si es un VCE o Marine, necesitamos minerales
				(imply (or (esUnidad ?unid VCE) (esUnidad ?unid Marine) ) (estaExtrayendoRecurso Mineral) )

				; si es segador, minerales y gas
				(imply (esUnidad ?unid Segador) (and (estaExtrayendoRecurso Mineral) (estaExtrayendoRecurso Gas)) )

				; el edificio donde se recluta esta en la localizacion
				(entidadEnLocalizacion ?edificio ?loc)

				; si es un centro de mando, la unidad a reclutar tiene que ser VCE
				(imply (esEdificio ?edificio CentroDeMando) (esUnidad ?unid VCE))

				; si es marine o segador se recluta en los Barracones
				(imply (esEdificio ?edificio Barracones) (or  (esUnidad ?unid Marine) (esUnidad ?unid Segador) ) )
			)

		:effect
			( and
				; añadimos la unidad a esa localizacion y dicha unidad está libre
				(entidadEnLocalizacion ?unid ?loc)
				(unidadLibre ?unid)
			)

	)

)
