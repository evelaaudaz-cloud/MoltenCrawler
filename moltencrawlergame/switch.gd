extends Area2D

@onready var luz = $PointLight2D
@onready var timer = $Timer

var esta_encendida = false

func _ready():
	luz.enabled = false
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	# Conectamos las señales de área para saber quién entra y sale
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Si entra el jugador, se enciende
	if body.is_in_group("jugador"):
		encender()
	
	# Si entra un enemigo y la luz ya está encendida, lo asustamos
	if body.is_in_group("enemigos") and esta_encendida:
		if body.has_method("reaccionar_a_luz"):
			body.reaccionar_a_luz(true, global_position)

func _on_body_exited(body):
	# Al salir del radio, el enemigo deja de huir
	if body.is_in_group("enemigos"):
		if body.has_method("reaccionar_a_luz"):
			body.reaccionar_a_luz(false, global_position)

func encender():
	if esta_encendida: return # Evita reiniciar si ya brilla
	
	esta_encendida = true
	luz.enabled = true
	modulate = Color(1.5, 1.5, 1.5)
	timer.start(10.0) # 4 segundos de duración
	
	# NOTA IMPORTANTE: Al encenderse, debemos avisar a los enemigos 
	# que YA ESTABAN dentro del área antes de encenderse.
	actualizar_enemigos_en_rango(true)

func _on_timer_timeout():
	esta_encendida = false
	luz.enabled = false
	modulate = Color.WHITE
	# Avisamos a los enemigos que la luz se apagó
	actualizar_enemigos_en_rango(false)

# Función mágica para repeler a todos los que estén cerca al activarse
func actualizar_enemigos_en_rango(hay_luz: bool):
	var cuerpos = get_overlapping_bodies()
	for cuerpo in cuerpos:
		if cuerpo.is_in_group("enemigos") and cuerpo.has_method("reaccionar_a_luz"):
			cuerpo.reaccionar_a_luz(hay_luz, global_position)
