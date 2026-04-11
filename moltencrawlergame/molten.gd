extends CharacterBody2D

@export var speed = 300.0
@export var velocidad_agua = 150.0
@export var daño_agua_por_segundo = 3.0
var esta_parpadeando = false

@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

@export var salud_maxima = 100
var salud_actual = 100
var llaves = 0
var esta_caminando = false
var esta_en_agua = false

signal salud_cambiada(nueva_salud)

func _ready():
	salud_actual = salud_maxima
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	nav_agent.path_max_distance = 10.0 

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target_pos = get_global_mouse_position()
		nav_agent.target_position = target_pos
		esta_caminando = true
		anim_player.play("walk")

func _physics_process(delta):
	detectar_suelo()
	
	if esta_en_agua:
		recibir_daño(daño_agua_por_segundo * delta)

	if nav_agent.is_navigation_finished():
		if esta_caminando:
			esta_caminando = false
			anim_player.play("idle")
			velocity = Vector2.ZERO
			if has_node("SonidoPasos"): $SonidoPasos.stop() 
		return

	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	
	var velocidad_actual = speed
	if esta_en_agua:
		velocidad_actual = velocidad_agua

	if next_path_pos.x < global_position.x - 2:
		sprite.flip_h = true
	elif next_path_pos.x > global_position.x + 2:
		sprite.flip_h = false
		
	velocity = direction * velocidad_actual
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	if has_node("SonidoPasos") and not $SonidoPasos.playing:
		$SonidoPasos.play()
	move_and_slide()

func detectar_suelo():
	esta_en_agua = false
	var posicion_pies = global_position + Vector2(0, 10)
	
	# 1. Buscamos las capas
	var capas = get_tree().get_nodes_in_group("capas_agua")
	
	# DEBUG: Si esto imprime 0, es que olvidaste añadir el grupo a la capa en la escena de la sala
	if capas.size() == 0:
		print("ERROR: No encontré ninguna capa en el grupo 'capas_agua'")
	
	for capa in capas:
		var local_pos = capa.to_local(posicion_pies)
		var map_pos = capa.local_to_map(local_pos)
		var data = capa.get_cell_tile_data(map_pos)
		
		if data:
			# DEBUG: Esto nos dirá qué está leyendo Molten bajo sus pies
			var valor_tipo = data.get_custom_data("tipo")
			
			if valor_tipo == "agua":
				esta_en_agua = true
				return
				
func recibir_daño(cantidad):
	# Si Molten ya no está en el juego, no hacemos nada
	if not is_inside_tree():
		return

	salud_actual -= cantidad
	salud_actual = clamp(salud_actual, 0, salud_maxima)
	emit_signal("salud_cambiada", salud_actual)
	
	# Si murió, cambiamos de escena y SALIMOS de la función inmediatamente
	if salud_actual <= 0:
		morir()
		return # <-- Este return evita que el código de abajo explote
		
	# Si sigue vivo, lo hacemos parpadear (pero solo 1 vez cada 0.1 segundos)
	if not esta_parpadeando:
		esta_parpadeando = true
		modulate = Color.RED
		
		# Esperamos 0.1 segundos
		await get_tree().create_timer(0.1).timeout
		
		# Verificamos que Molten siga existiendo antes de despintarlo
		if is_inside_tree():
			modulate = Color.WHITE
			esta_parpadeando = false

func morir():
	set_physics_process(false)
	var nivel_donde_estoy = get_tree().current_scene.scene_file_path
	GameManager.jugador_murio(nivel_donde_estoy)

func obtener_llave():
	llaves += 1
	print("Llaves: ", llaves)

func usar_llave():
	llaves -= 1
