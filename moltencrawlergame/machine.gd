extends StaticBody2D

@export var escena_comida = preload("res://comida.tscn") 
@export var tiempo_espera = 5.0 

@onready var label_e = $CanvasLayer/Label
@onready var timer = $TimerCooldown
@onready var marker = $Marker2D

var jugador_cerca = false
var disponible = true

func _ready():
	label_e.hide()
	if not timer.timeout.is_connected(_on_timer_cooldown_timeout):
		timer.timeout.connect(_on_timer_cooldown_timeout)
	
	timer.wait_time = tiempo_espera
	timer.one_shot = true

func _process(_delta):
	if jugador_cerca and disponible and Input.is_action_just_pressed("interactuar"):
		soltar_comida()

func soltar_comida():
	disponible = false
	label_e.text = "Cargando..."
	
	var comida = escena_comida.instantiate()
	get_parent().add_child.call_deferred(comida)
	comida.global_position = marker.global_position
	
	timer.start()

func _on_timer_cooldown_timeout():
	disponible = true
	if jugador_cerca:
		label_e.text = "[E]"
		label_e.show()

func _on_area_2d_body_entered(body):
	if body.name == "Molten": 
		jugador_cerca = true
		if disponible:
			label_e.text = "[E]"
		else:
			label_e.text = "Cargando..."
		label_e.show()

func _on_area_2d_body_exited(body):
	if body.name == "Molten":
		jugador_cerca = false
		label_e.hide()
