(define (domain ejercicio_6)
	(:requirements :strips :adl :fluents)

	(:types
		; tenemos los tipos explicados
		entidad localizacion - object

		; tanto los edificios como las unidades serán entidades
		; para hacer más facil el comprobar que está en cada sitio, etc
		unidad - entidad
		edificio - entidad

		; en este ejercicio añadimos las investigaciones
		investigacion - entidad

		; tipos para las constantes, derivados de los originales
		; al ser una especialización
		recurso - object
		tipoEdificio - edificio
		tipoUnidad - unidad
		tipoRecurso - recurso
		tipoInvestigacion - investigacion
	)

	(:constants
		; constantes para evitar tener que estar declarando
		; muchos objetos
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

		; para comprobar si una unidad está libre
		(unidadLibre ?uni - unidad)

		; para comprobar si un edificio, unidad e investigacion es de cierto tipo
		(esEdificio ?edif - edificio ?tipoEdif - tipoEdificio)
		(esUnidad ?unid - unidad ?tUnid - tipoUnidad)
		(esInvestigacion ?inves - investigacion ?tInves - tipoInvestigacion )

		; para comprobar si tenemos cierta investigacion
		(heInvestigado ?invest - investigacion)
	)

	; para este ejercicio añadimos funciones para gestionar la cantidad
	; de recursos necesarios y almacenes, así como cuantas unidades
	; extraen un tipo de recursos
	; asi como las de gestionar el tiempo
	(:functions
		(necesitaRecurso ?x - entidad ?rec - recurso)
		(recursoAlmacenado ?tipoRecurso - tipoRecurso )
		(topeRecurso ?tipoRecurso - tipoRecurso)
		(unidadesExtrayendo ?tipoRecurso - tipoRecurso)

		; tiempo necesario para una entidad
		(tiempoNecesario ?ent - entidad)

		; tiempo transcurrido esto es lo que intentamos minimizar
		(tiempoTrascurrido)

		; tiempo necesario de la accion recolectar
		(tiempoRecolectar)

		; distancia entre dos localizaciones, todas las casillas tienen la misma
		; distancia entre si
		(distanciaLocalizaciones)

		; velocidad de cada unidad
		(velocidad ?tUnid - tipoUnidad)
	)

	(:action navegar
		; como parametro la unidad, y dos localizaciones, la actual y la nueva
	  :parameters (?unidad - unidad ?tUnid - tipoUnidad ?x ?y - localizacion)
	  :precondition
	  		(and
				; como precondicion, tiene que estar en la primera localizacion
				(entidadEnLocalizacion ?unidad ?x)

				; las localizaciones tienen que estar conectadas
				(caminoEntre ?x ?y)

				; la unidad tiene que estar libre (no extrayendo recursos)
				(unidadLibre ?unidad)

				; esto lo hacemos para saber de forma más facil el tipo de unicdad
				(esUnidad ?unidad ?tUnid)
			)

	  :effect
	  		(and
				; la unidad cambia de estar en x a estar en y
				(entidadEnLocalizacion ?unidad ?y)
				(not (entidadEnLocalizacion ?unidad ?x))

				; incrementamos al tiempo transcurrido la distancia por la velocidad
				(increase
					(tiempoTrascurrido)
					(*
						(distanciaLocalizaciones)
						(velocidad ?tUnid)
					)
				)
			)
	)

	(:action asignar
		; accion para asignar una unidad a extraer un recurso en una localizacion
	  :parameters (?x - unidad ?rec - tipoRecurso ?loc - localizacion ?edi - edificio)
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

				; cuando una unidad se pone a extraer un recurso
				; la contamos, para despues saber cuanto sumar al recolectar
				(increase
					(unidadesExtrayendo ?rec)
					1
				)
			)
	)

	(:action desasignar
		; accion para desasignar una unidad de extraer un recurso
		:parameters (?unid - unidad ?loc - localizacion ?rec - tipoRecurso)
		:precondition
			(and
				; si la unidad no esta libre y esta en una localizacion
				; donde esta el recurso
				(not (unidadLibre ?unid))
				(entidadEnLocalizacion ?unid ?loc)
				(asignarNodoRecursoLocalizacion ?rec ?loc)
			)

		:effect
			(and
				; hacemos que la unidad pase a estar libre
				(unidadLibre ?unid)

				;ahora hay una unidad menos extrayendo ese recurso
				(decrease
					(unidadesExtrayendo ?rec)
					1
				)

				; cuando es la ultima unidad extrayendo ese recurso
				; ya no se esta extrayendo el recurso
				(when (and (not (> (unidadesExtrayendo ?rec) 0) ) )
					(and
						(not (estaExtrayendoRecurso ?rec))
					)
				)
			)

	)

	(:action construir
		; acción para construir un edificio - para este ejercicio pueden necesitar varios recursos
	  :parameters (?unidad - unidad ?x - localizacion ?edificio - edificio ?tEdif - tipoEdificio)
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
					(and
						; el edificio es de su tipo
						(esEdificio ?edificio ?tEdif)

						; tenemos almacenes suficientemente grandes
						; para almacenarlo, esto lo hacemos para que sea
						; más rápido
						(>=
							(topeRecurso ?r)
							(necesitaRecurso ?tEdif ?r)
						)

						; tenemos suficientes recursos
						(>=
							(recursoAlmacenado ?r)
							(necesitaRecurso ?tEdif ?r)
						)

					)
				)

			)

	  :effect
	  		(and
				; como efecto tenemos el edificio
				(entidadEnLocalizacion ?edificio ?x)

				; restamos los minerales usados
				(decrease
					(recursoAlmacenado Mineral)
					(necesitaRecurso ?tEdif Mineral)
				)

				; restamos el gas usado
				(decrease
					(recursoAlmacenado Gas)
					(necesitaRecurso ?tEdif Gas)
				)

				; cuando se construye un deposito, aumentamos los topes de los recursos
				(when (and (esEdificio ?edificio Deposito) )
					(and
						(increase (topeRecurso Gas) 100)
						(increase (topeRecurso Mineral) 100)
					)
				)

				; incrementamos el tiempo transcurrido el tiempo que necesita ese edificio
				(increase
					(tiempoTrascurrido)
					(tiempoNecesario ?tEdif)
				)
			)
	)

	(:action reclutar
		; accion para reclutar unidades, necesitamos la unidad y el edificio y localizacion
		; donde se va a construir
		:parameters (?unid - unidad ?tUnid - tipoUnidad ?edificio - edificio ?loc - localizacion)
		:precondition
			(and
				; la unidad es del tipo dado por paramteo
				; esto nos facilitará el saber los tipo más adelante
				(esUnidad ?unid ?tUnid)

				; para reclutar la unidad dicha unidad no puede estar en ninguna localizacion
				(not (exists (?l - localizacion) (and  (entidadEnLocalizacion ?unid ?l)) ) )

				; para los tipos de recursos
				(forall (?tRes - tipoRecurso)
					(and
						; tengo suficiente espacio y suficientes recursos
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

				; si es un segador tengo que tener la investigación
				; sacada
				(imply
					(esUnidad ?unid Segador)
					(and
						(exists (?t - investigacion) (and (heInvestigado ?t) (esInvestigacion ?t ImpulsorSegador)) )
					)
				)

				; el edificio donde se recluta esta en esa localizacion
				(entidadEnLocalizacion ?edificio ?loc)

				; si es un centro de mando, la unidad a reclutar tiene que ser VCE
				(imply (esUnidad ?unid VCE) (esEdificio ?edificio CentroDeMando) )

				; si es marine o segador se recluta en los Barracones
				(imply (or  (esUnidad ?unid Marine) (esUnidad ?unid Segador) ) (esEdificio ?edificio Barracones) )
			)

		:effect
			( and
				; añadimos la unidad a esa localizacion y dicha unidad está libre
				(entidadEnLocalizacion ?unid ?loc)
				(unidadLibre ?unid)

				; restamos los materiales usados
				(decrease
					(recursoAlmacenado Mineral)
					(necesitaRecurso ?tUnid Mineral)
				)
				(decrease
					(recursoAlmacenado Gas)
					(necesitaRecurso ?tUnid Gas)
				)

				; aumentamos el tiempo que necesitamos para reclutar
				; dicha unidad
				(increase
					(tiempoTrascurrido)
					(tiempoNecesario ?tUnid)
				)
			)

	)


	(:action investigar
		; acción para investigar
		:parameters (?inves - investigacion ?edif - edificio ?tInves - tipoInvestigacion)

		:precondition
			(and
				; investigamos en la bahia de ingeniería
				(esInvestigacion ?inves ?tInves)

				;la bahia de investigación tiene que estar construida en una localizacion
				(esEdificio ?edif BahiaIngenieria)
				(exists (?l - localizacion) (entidadEnLocalizacion ?edif ?l) )

				; todavia no he investigado la investigacion
				(not (heInvestigado ?inves))

				;tengo los recursos necesarios
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
				; como resultado, hemos hecho la investigacion
				(heInvestigado ?inves)

				; resto los recursos utilizados
				(decrease
					(recursoAlmacenado Mineral)
					(necesitaRecurso ?tInves Mineral)
				)
				(decrease
					(recursoAlmacenado Gas)
					(necesitaRecurso ?tInves Gas)
				)

				; aumentamos el tiempo transcurrido
				(increase
					(tiempoTrascurrido)
					(tiempoNecesario ?tInves)
				)
			)

	)

	(:action recolectar
		; accion para recolectar recursos
		:parameters (?rec - tipoRecurso)
		:precondition
			(and
				; se esta extrayendo el recurso a extraer
				(estaExtrayendoRecurso ?rec)

				; tenemos espacio en los almacenes
				(<
					(recursoAlmacenado ?rec)
					(topeRecurso ?rec)
				)

			)


		:effect
			(and
				; incrementamos el recurso almacenado
				; 25 por el número de unidades extrayendolo
				; uso 25 y no 10 ya que si no tarda demasiado
				(increase
					(recursoAlmacenado ?rec)
					(*
						25
						(unidadesExtrayendo ?rec)
					)
				)

				; aumentamos el tiempo que tardamos en recolectar
				(increase
					(tiempoTrascurrido)
					(tiempoRecolectar)
				)
			)
	)

)
