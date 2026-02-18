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
	objetivo = get_tree().get_first_node_in_group("jugador")
	
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
	
	if not objetivo or not is_instance_valid(agente_navegacion):
		return
		
	if en_la_luz:
		var direccion_huida = self.global_position.direction_to(posicion_de_la_lampara) * -1
		velocity = direccion_huida * fuerza_repulsion
		modulate.a = 0.4
	else:
		modulate.a = 1.0
		agente_navegacion.target_position = objetivo.global_position
		
		var siguiente_punto = agente_navegacion.get_next_path_position()
		
		var direccion_inteligente = self.global_position.direction_to(siguiente_punto)
		velocity = direccion_inteligente * velocidad
	
	
	$Sprite2D.rotation += 1
	$NavigationAgent2D/AnimationPlayer.play("idle")
	move_and_slide()

func _on_zona_ataque_body_entered(body):
	if body.is_in_group("jugador") and not atacando:
		
		if body.has_method("recibir_daño"):
			body.recibir_daño(daño)
		
		atacando = true
		
		var direccion_choque = global_position.direction_to(body.global_position)
		
		body.velocity = direccion_choque * 600
		body.move_and_slide()
		
		velocity = -direccion_choque * 400 
		
		await get_tree().create_timer(0.5).timeout
		
		atacando = false
