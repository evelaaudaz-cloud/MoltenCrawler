extends CharacterBody2D

@export var speed = 300.0
@onready var nav_agent = $NavigationAgent2D # Referencia al cerebro de navegación

func _unhandled_input(event):
	# Si el usuario hace clic con el botón izquierdo
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Le decimos al agente que nuestra meta es la posición del ratón
		nav_agent.target_position = get_global_mouse_position()

func _physics_process(_delta):
	# Si ya llegamos al destino, nos detenemos
	if nav_agent.is_navigation_finished():
		return

	# Calculamos hacia dónde movernos para llegar a la meta
	var current_pos = global_position
	var next_path_pos = nav_agent.get_next_path_position()
	
	# Calculamos la dirección y la velocidad
	var new_velocity = (next_path_pos - current_pos).normalized() * speed
	
	# Aplicamos el movimiento
	velocity = new_velocity
	move_and_slide()
