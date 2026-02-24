extends CharacterBody2D

@export var speed = 300.0
@export var velocidad_agua = 150.0
@export var daño_agua_por_segundo = 3.0

@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

@export var salud_maxima = 100
var salud_actual = 100
var llaves = 0
var esta_caminando = false
var esta_en_agua = false

@export var capa_agua : TileMapLayer

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
			$SonidoPasos.stop() 
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
	
	if not $SonidoPasos.playing:
		$SonidoPasos.play()
	move_and_slide()

func detectar_suelo():
	if not capa_agua:
		capa_agua = get_tree().current_scene.find_child("TileMapLayer2", true, false) as TileMapLayer
	if not capa_agua:
		esta_en_agua = false
		return

	var posicion_pies = global_position + Vector2(0, 10)
	var local_pos = capa_agua.to_local(posicion_pies)
	var map_pos = capa_agua.local_to_map(local_pos)
	
	var data = capa_agua.get_cell_tile_data(map_pos)
	
	if data:
		var tipo = data.get_custom_data("tipo")
		if tipo == "agua":
			esta_en_agua = true
		else:
			esta_en_agua = false
	else:
		esta_en_agua = false

func recibir_daño(cantidad):
	salud_actual -= cantidad
	salud_actual = clamp(salud_actual, 0, salud_maxima)
	emit_signal("salud_cambiada", salud_actual)
	
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if salud_actual <= 0:
		morir()

func morir():
	set_physics_process(false)
	var nivel_donde_estoy = get_tree().current_scene.scene_file_path
	GameManager.jugador_murio(nivel_donde_estoy)


func obtener_llave():
	llaves += 1
	print("Llaves: ", llaves)

func usar_llave():
	llaves -= 1
