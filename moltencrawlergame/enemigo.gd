extends CharacterBody2D

@export var velocidad = 170.0
@export var fuerza_repulsion = 300.0
@export var daño = 35
var atacando = false

@onready var agente_navegacion = $NavigationAgent2D
@onready var sprite = $Sprite2D

var objetivo = null
var en_la_luz = false
var posicion_de_la_lampara = Vector2.ZERO

func _ready():
	add_to_group("enemigos")
	await get_tree().process_frame
	objetivo = get_tree().get_first_node_in_group("jugador")
	
	if agente_navegacion:
		agente_navegacion.path_desired_distance = 15.0
		agente_navegacion.target_desired_distance = 15.0

func reaccionar_a_luz(dentro: bool, fuente_luz_pos: Vector2):
	en_la_luz = dentro
	posicion_de_la_lampara = fuente_luz_pos

func _physics_process(delta):
	# 1. PRIORIDAD: SISTEMA DE KNOCKBACK (Si está rebotando, no hace nada más)
	if atacando:
		move_and_slide()
		velocity = velocity.move_toward(Vector2.ZERO, 800 * delta)
		return
	
	# 2. SEGUNDA PRIORIDAD: MOVER AL ENEMIGO (Luz o Persecución)
	mover_enemigo(delta)

func mover_enemigo(delta):
	if en_la_luz:
		# Lógica de huida (Siempre funciona, haya jugador o no)
		var direccion_huida = global_position.direction_to(posicion_de_la_lampara) * -1
		velocity = direccion_huida * fuerza_repulsion
		modulate.a = 0.4
	elif objetivo and is_instance_valid(agente_navegacion):
		# Lógica de persecución
		modulate.a = 1.0
		agente_navegacion.target_position = objetivo.global_position
		var siguiente_punto = agente_navegacion.get_next_path_position()
		var direccion = global_position.direction_to(siguiente_punto)
		velocity = direccion * velocidad
	else:
		# Si no hay luz ni jugador, se queda quieto
		velocity = velocity.move_toward(Vector2.ZERO, 500 * delta)

	# Visuales y Movimiento final
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	sprite.rotation += 10 * delta
	move_and_slide()

func _on_zona_ataque_body_entered(body):
	if not is_inside_tree() or atacando: return
	
	if body.is_in_group("jugador"):
		atacando = true
		if body.has_method("recibir_daño"):
			body.recibir_daño(daño)
		
		var direccion_choque = global_position.direction_to(body.global_position)
		
		# Knockback al jugador
		if body is CharacterBody2D:
			body.velocity = direccion_choque * 700
		
		# Rebote del enemigo
		velocity = -direccion_choque * 500
		
		var tree = get_tree()
		if tree:
			await tree.create_timer(0.4).timeout
		
		if is_inside_tree():
			atacando = false
