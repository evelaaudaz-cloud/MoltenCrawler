extends Node2D

@export_group("Escenas")
@export var salas_normales: Array[PackedScene]
@export var salas_generador: Array[PackedScene]
@export var salas_enemigos: Array[PackedScene]
@export var sala_muro: PackedScene
@export var tronco_escena: PackedScene
@export var enemigo_escena: PackedScene

@export_group("Ajustes de Grid")
@export var ancho_sala: float = 128.0
@export var alto_sala: float = 128.0

@onready var nav_region = $NavigationRegion2D 

# Variable para guardar TODOS los puntos de spawn de salas normales
var puntos_para_troncos: Array[Marker2D] = []

func _ready():
	GameManager.reset_progreso()
	puntos_para_troncos.clear() # Limpiamos por si acaso
	generar_mazmorra_completa()
	
	# Una vez generado todo el mapa, ponemos los 3 troncos
	colocar_troncos_globales(3)
	
	if has_node("Molten"):
		var molten = $Molten
		molten.global_position = Vector2(64, 64)
		molten.z_index = 10
		var barra = find_child("ProgressBar", true, false) as ProgressBar
		if barra:
			barra.max_value = molten.salud_maxima
			barra.value = molten.salud_actual
			molten.salud_cambiada.connect(func(nueva_salud): barra.value = nueva_salud)

	call_deferred("actualizar_navegacion")

func generar_mazmorra_completa():
	for y in range(5):
		for x in range(5):
			var muro = sala_muro.instantiate()
			muro.position = Vector2(x * ancho_sala, y * alto_sala)
			add_child(muro)

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
	
	var candidatos = celdas_visitadas.duplicate()
	candidatos.erase(Vector2(0,0))
	candidatos.shuffle()

	var puntos_gen = []
	for i in range(3):
		if candidatos.size() > 0: puntos_gen.append(candidatos.pop_back())

	var puntos_enemigos = []
	for i in range(3):
		if candidatos.size() > 0: puntos_enemigos.append(candidatos.pop_back())

	for celda in celdas_visitadas:
		var sala_inst
		var es_sala_enemiga = false
		var es_sala_normal = false
		
		if celda in puntos_gen:
			sala_inst = salas_generador.pick_random().instantiate()
			GameManager.registrar_generador()
		elif celda in puntos_enemigos:
			sala_inst = salas_enemigos.pick_random().instantiate()
			es_sala_enemiga = true
		else:
			sala_inst = salas_normales.pick_random().instantiate()
			es_sala_normal = true
		
		sala_inst.position = Vector2(celda.x * ancho_sala, celda.y * alto_sala)
		sala_inst.z_index = 1
		add_child(sala_inst)
		
		if es_sala_enemiga:
			spawnear_horda_en_sala(sala_inst)
		elif es_sala_normal:
			# En lugar de poner el tronco ya, guardamos sus puntos
			recolectar_puntos_de_tronco(sala_inst)

func recolectar_puntos_de_tronco(sala_nodo):
	# Buscamos todos los Marker2D de esta sala y los guardamos en la lista global
	for hijo in sala_nodo.find_children("*", "Marker2D", true):
		if hijo.is_in_group("puntos_spawn"):
			puntos_para_troncos.append(hijo)

func colocar_troncos_globales(cantidad: int):
	if puntos_para_troncos.size() == 0: return
	
	puntos_para_troncos.shuffle()
	
	# Ponemos máximo la cantidad pedida (3) o los puntos que existan
	var total_a_poner = min(cantidad, puntos_para_troncos.size())
	
	for i in range(total_a_poner):
		var t = tronco_escena.instantiate()
		# Al usar add_child en el Marker2D, solo habrá 1 por cada uno
		puntos_para_troncos[i].add_child(t)

func spawnear_horda_en_sala(sala_nodo):
	var nivel = GameManager.nivel_actual
	var cantidad = randi_range(1, 2) + (nivel - 1)
	
	var puntos = []
	for hijo in sala_nodo.find_children("*", "Marker2D", true):
		if hijo.is_in_group("puntos_spawn"):
			puntos.append(hijo)
	
	if puntos.size() == 0: return
	puntos.shuffle()
	
	for i in range(cantidad):
		var p_escogido = puntos[i % puntos.size()]
		var e = enemigo_escena.instantiate()
		add_child(e)
		e.global_position = p_escogido.global_position + Vector2(randf_range(-8, 8), randf_range(-8, 8))
		e.z_index = 10

func actualizar_navegacion():
	if nav_region:
		nav_region.bake_navigation_polygon()
