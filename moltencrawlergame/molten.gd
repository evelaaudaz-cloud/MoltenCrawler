extends CharacterBody2D

@export var speed = 300.0
@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

var esta_caminando = false

func _unhandled_input(event):
	# Bloqueo: Si ya está caminando, ignoramos cualquier clic nuevo
	if esta_caminando:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target_pos = get_global_mouse_position()
		nav_agent.target_position = target_pos
		esta_caminando = true
		anim_player.play("walk")

func _physics_process(_delta):
	# Si el agente dice que terminamos el camino
	if nav_agent.is_navigation_finished():
		if esta_caminando:
			esta_caminando = false
			anim_player.play("idle")
		return

	var next_path_pos = nav_agent.get_next_path_position()
	var current_pos = global_position
	
	# Calculamos la dirección para movernos y para voltear el sprite
	var direction = (next_path_pos - current_pos).normalized()
	
	# Voltear el sprite según la dirección X
	if direction.x < 0:
		sprite.flip_h = true  # Izquierda
	elif direction.x > 0:
		sprite.flip_h = false # Derecha
	
	velocity = direction * speed
	move_and_slide()
