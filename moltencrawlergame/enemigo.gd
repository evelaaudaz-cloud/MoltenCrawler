extends CharacterBody2D

@export var velocidad = 160.0
@export var fuerza_repulsion = 250.0
@export var daño = 30
var atacando = false
@onready var agente_navegacion = $NavigationAgent2D

var objetivo = null
var en_la_luz = false
var posicion_de_la_lampara = Vector2.ZERO

func _ready():
	add_to_group("enemigos")
	# Buscamos al nodo que esté en el grupo jugador
	objetivo = get_tree().get_first_node_in_group("jugador")
	
	# Ajustes de seguridad para el agente
	if agente_navegacion:
		agente_navegacion.path_desired_distance = 10.0
		agente_navegacion.target_desired_distance = 10.0

func reaccionar_a_luz(dentro: bool, fuente_luz_pos: Vector2):
	en_la_luz = dentro
	posicion_de_la_lampara = fuente_luz_pos

func _physics_process(_delta):
	if atacando:
		move_and_slide()
		return
	if not objetivo: return
	
	# 1. Verificación de seguridad
	if not objetivo or not is_instance_valid(agente_navegacion):
		return

	# 2. Lógica de movimiento
	if en_la_luz:
		# USAMOS global_position DEL CUERPO (EL ENEMIGO), NO DEL AGENTE
		var direccion_huida = self.global_position.direction_to(posicion_de_la_lampara) * -1
		velocity = direccion_huida * fuerza_repulsion
		modulate.a = 0.4
	else:
		modulate.a = 1.0
		# Actualizar el destino del GPS
		agente_navegacion.target_position = objetivo.global_position
		
		# Obtener el siguiente punto del mapa de navegación
		var siguiente_punto = agente_navegacion.get_next_path_position()
		
		# Calculamos la dirección desde la posición del ENEMIGO
		var direccion_inteligente = self.global_position.direction_to(siguiente_punto)
		velocity = direccion_inteligente * velocidad

	# 3. Aplicar rotación visual y movimiento físico
	$Sprite2D.rotation += 1
	$NavigationAgent2D/AnimationPlayer.play("idle")
	move_and_slide()
	
	

func _on_zona_ataque_body_entered(body):
	# Verificamos que no estemos ya atacando para evitar bugs raros
	if body.is_in_group("jugador") and not atacando:
		
		# 1. Hacemos daño
		if body.has_method("recibir_daño"):
			body.recibir_daño(daño)
		
		# 2. Activamos el estado de ataque
		atacando = true
		
		# --- FÍSICA DE SEPARACIÓN ---
		# Calculamos la dirección del choque
		var direccion_choque = global_position.direction_to(body.global_position)
		
		# EMPUJÓN A MOLTEN (Lo mandamos lejos)
		body.velocity = direccion_choque * 600
		body.move_and_slide()
		
		# EMPUJÓN AL ENEMIGO (Nosotros también retrocedemos)
		# Esto es lo que evita que se quede pegado
		velocity = -direccion_choque * 400 
		
		# 3. Tiempo de recuperación (Cooldown)
		# El enemigo se queda "atontado" 0.5 segundos tras golpear
		await get_tree().create_timer(0.5).timeout
		
		# Volvemos a la normalidad
		atacando = false
