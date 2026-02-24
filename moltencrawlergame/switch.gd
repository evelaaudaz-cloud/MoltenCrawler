extends Area2D

@onready var luz = $PointLight2D
@onready var timer = $Timer

var esta_encendida = false

func _ready():
	luz.enabled = false
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		encender()
	if body.is_in_group("enemigos") and esta_encendida:
		if body.has_method("reaccionar_a_luz"):
			body.reaccionar_a_luz(true, global_position)

func _on_body_exited(body):
	if body.is_in_group("enemigos"):
		if body.has_method("reaccionar_a_luz"):
			body.reaccionar_a_luz(false, global_position)

func encender():
	if esta_encendida: return
	esta_encendida = true
	luz.enabled = true
	modulate = Color(1.5, 1.5, 1.5)
	timer.start(10.0)
	actualizar_enemigos_en_rango(true)

func _on_timer_timeout():
	esta_encendida = false
	luz.enabled = false
	modulate = Color.WHITE
	actualizar_enemigos_en_rango(false)

func actualizar_enemigos_en_rango(hay_luz: bool):
	var cuerpos = get_overlapping_bodies()
	for cuerpo in cuerpos:
		if cuerpo.is_in_group("enemigos") and cuerpo.has_method("reaccionar_a_luz"):
			cuerpo.reaccionar_a_luz(hay_luz, global_position)
