extends CharacterBody2D

@export var speed = 300.0
@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

var esta_caminando = false

@export var salud_maxima = 100
var salud_actual = 100

signal salud_cambiada(nueva_salud)

func _ready():
	# Configuración para que el agente sea más estricto con el centro del camino
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	# IMPORTANTE: Esto ayuda a que no intente atravesar esquinas
	nav_agent.path_max_distance = 10.0 

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
	get_tree().reload_current_scene()
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target_pos = get_global_mouse_position()
		nav_agent.target_position = target_pos
		esta_caminando = true
		anim_player.play("walk")

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		if esta_caminando:
			esta_caminando = false
			anim_player.play("idle")
			velocity = Vector2.ZERO # Detenemos la inercia por completo
		return

	# Obtenemos el siguiente punto calculado por el NavigationServer
	var next_path_pos = nav_agent.get_next_path_position()
	
	# LÓGICA DE "TAXISTA": 
	# En lugar de ir directo, calculamos el vector hacia el centro del siguiente tile
	var direction = global_position.direction_to(next_path_pos)
	
	# Rotación de Sprite
	if next_path_pos.x < global_position.x - 2:
		sprite.flip_h = true
	elif next_path_pos.x > global_position.x + 2:
		sprite.flip_h = false

	# Aplicamos la velocidad
	velocity = direction * speed
	
	# Forzamos modo flotante para evitar fricción de suelo invisible
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	# Esta es la clave: move_and_slide procesará la colisión, 
	# pero el nav_agent nos mantendrá en la ruta segura.
	move_and_slide()

	# CORRECCIÓN DE POSICIÓN MÍNIMA:
	# Si estamos muy cerca de un muro, el NavigationAgent debería corregirnos.
	# Asegúrate de tener el "Agent Radius" en el NavigationRegion2D configurado.
