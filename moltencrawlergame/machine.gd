extends StaticBody2D

@export var escena_comida = preload("res://comida.tscn") # Arrastra aquí tu escena de comida
@export var tiempo_espera = 5.0 # Segundos entre bocadillos

@onready var label_e = $CanvasLayer/Label
@onready var timer = $TimerCooldown
@onready var marker = $Marker2D

var jugador_cerca = false
var disponible = true

func _ready():
	label_e.hide()
	timer.wait_time = tiempo_espera
	timer.one_shot = true

func _process(_delta):
	# Si presionamos E, estamos cerca y la máquina no está en cooldown
	if jugador_cerca and disponible and Input.is_action_just_pressed("interactuar"):
		soltar_comida()

func soltar_comida():
	disponible = false
	label_e.text = "Cargando..."
	
	# Instanciamos tu bocadillo
	var comida = escena_comida.instantiate()
	get_parent().add_child(comida)
	comida.global_position = marker.global_position
	
	# Iniciar cooldown
	timer.start()

func _on_timer_cooldown_timeout():
	disponible = true
	if jugador_cerca:
		label_e.text = "[E]"
	else:
		label_e.hide()

# --- DETECCIÓN DE PROXIMIDAD ---
func _on_area_2d_body_entered(body):
	if body.name == "Molten": # O el nombre de tu nodo jugador
		jugador_cerca = true
		label_e.show()
		if disponible:
			label_e.text = "[E]"
		else:
			label_e.text = "Cargando..."

func _on_area_2d_body_exited(body):
	if body.name == "Molten":
		jugador_cerca = false
		label_e.hide()
