extends CharacterBody2D

@export var speed = 300.0
@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

var esta_caminando = false

@export var salud_maxima = 100
var salud_actual = 100

# Señal para avisar a la interfaz cuando nos golpean
signal salud_cambiada(nueva_salud)

func recibir_daño(cantidad):
	salud_actual -= cantidad
	salud_actual = clamp(salud_actual, 0, salud_maxima) # Evita que baje de 0
	
	emit_signal("salud_cambiada", salud_actual)
	
	# Efecto visual de golpe: Molten se pone rojo un segundo
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if salud_actual <= 0:
		morir()

func morir():
	print("Molten se ha derretido...")
	get_tree().reload_current_scene() # Por ahora, reinicia el nivel
	
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
	# Si ya llegamos, nos quedamos quietos
	if nav_agent.is_navigation_finished():
		if esta_caminando:
			esta_caminando = false
			anim_player.play("idle")
		return

	# Obtenemos el siguiente punto del camino
	var next_path_pos = nav_agent.get_next_path_position()
	
	# --- EL ARREGLO PARA VOLTEAR ---
	# Comparamos la X del destino con la X actual de Molten
	if next_path_pos.x < global_position.x - 2: # El -2 es para evitar que "tiemble" por errores de precisión
		sprite.flip_h = true  # Izquierda
	elif next_path_pos.x > global_position.x + 2:
		sprite.flip_h = false # Derecha
	# -------------------------------

	# Movimiento normal
	var direction = global_position.direction_to(next_path_pos)
	velocity = direction * speed
	move_and_slide()
