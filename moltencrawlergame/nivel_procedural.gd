extends Node2D

@export_group("Escenas")
@export var salas_normales: Array[PackedScene]
@export var salas_generador: Array[PackedScene]
@export var sala_muro: PackedScene      # Sala llena de pared/colisión
@export var tronco_escena: PackedScene
@export var enemigo_escena: PackedScene

@export_group("Ajustes de Grid")
@export var ancho_sala: float = 128.0
@export var alto_sala: float = 128.0

@onready var nav_region = $NavigationRegion2D 

func _ready():
	# 1. Limpieza de datos
	GameManager.reset_progreso()
	
	# 2. Construcción del mapa
	generar_mazmorra_completa()
	
	# 3. Configuración de Molten y el HUD
	if has_node("Molten"):
		var molten = $Molten
		molten.global_position = Vector2(64, 64)
		molten.z_index = 10
		
		# Buscamos el ProgressBar (asegúrate que el nombre en el Inspector sea 'ProgressBar')
		var barra = find_child("ProgressBar", true, false) as ProgressBar
		if barra:
			barra.max_value = molten.salud_maxima
			barra.value = molten.salud_actual
			# Conectamos la señal directamente a la barra
			molten.salud_cambiada.connect(func(nueva_salud): barra.value = nueva_salud)
			print("HUD: Conectado")
		else:
			print("HUD: No se encontró el nodo ProgressBar")

	# 4. Tareas diferidas (Navegación y Objetos)
	call_deferred("actualizar_navegacion")
	call_deferred("colocar_troncos_y_enemigos")

func generar_mazmorra_completa():
	# PASO A: Rellenar el fondo con muros (5x5 = 25 salas)
	for y in range(5):
		for x in range(5):
			var muro = sala_muro.instantiate()
			muro.position = Vector2(x * ancho_sala, y * alto_sala)
			muro.z_index = 0 
			add_child(muro)

	# PASO B: Calcular el camino aleatorio (15 pasos)
	var pos_actual = Vector2(0, 0)
	var celdas_visitadas = [pos_actual]
	
	for i in range(15):
		var direcciones = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
		direcciones.shuffle()
		for dir in direcciones:
			var nueva_pos = pos_actual + dir
			if nueva_pos.x >= 0 and nueva_pos.x < 5 and nueva_pos.y >= 0 and nueva_pos.y < 5:
				if not nueva_pos in celdas_visitadas:
					celdas_visitadas.append(nueva_pos)
					pos_actual = nueva_pos
					break
	
	# PASO C: Elegir 3 puntos del camino para las calderas
	var copia_camino = celdas_visitadas.duplicate()
	copia_camino.shuffle()
	var puntos_gen = []
	for i in range(3):
		if copia_camino.size() > 0:
			puntos_gen.append(copia_camino.pop_back())

	# PASO D: Instanciar las salas del camino ENCIMA de los muros
	for celda in celdas_visitadas:
		var sala_inst
		if celda in puntos_gen:
			sala_inst = salas_generador.pick_random().instantiate()
			GameManager.registrar_generador()
		else:
			sala_inst = salas_normales.pick_random().instantiate()
		
		sala_inst.position = Vector2(celda.x * ancho_sala, celda.y * alto_sala)
		sala_inst.z_index = 1 # IMPORTANTE: Mayor que el muro
		add_child(sala_inst)

func actualizar_navegacion():
	if nav_region:
		# Recalcula el área donde pueden caminar los enemigos
		nav_region.bake_navigation_polygon()
		print("Navegación actualizada")

func colocar_troncos_y_enemigos():
	# Buscamos los Marker2D que quedaron en las salas del camino
	var puntos = get_tree().get_nodes_in_group("puntos_spawn")
	puntos.shuffle()
	
	for i in range(3):
		if i < puntos.size():
			# Spawn del tronco
			var t = tronco_escena.instantiate()
			puntos[i].add_child(t)
			
			# Probabilidad del 25% para el enemigo
			if enemigo_escena != null and randf() <= 0.25:
				var e = enemigo_escena.instantiate()
				# Lo añadimos a la escena principal para evitar líos de escala
				add_child(e)
				e.global_position = puntos[i].global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
				e.z_index = 10 # Misma capa que Molten
