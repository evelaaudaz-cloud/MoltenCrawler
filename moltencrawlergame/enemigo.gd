extends CharacterBody2D

@export var velocidad = 150.0
@export var daño = 20
var objetivo = null

func _ready():
	# Buscamos a Molten en la escena al aparecer
	objetivo = get_parent().get_node("Molten")
	# Conectamos la señal para hacer daño
	$ZonaAtaque.body_entered.connect(_on_zona_ataque_body_entered)

func _physics_process(_delta):
	if objetivo:
		# Calculamos la dirección hacia Molten
		var direccion = global_position.direction_to(objetivo.global_position)
		velocity = direccion * velocidad
		
		# Efecto Technicolor: El engranaje rota constantemente
		$Sprite2D.rotation += 0.1
		
		move_and_slide()

func _on_zona_ataque_body_entered(body):
	if body.name == "Molten":
		# Usamos la función que creamos antes en el script de Molten
		body.recibir_daño(daño)
		
		# Pequeño empujón hacia atrás (Knockback) para que no le quite toda la vida de golpe
		var direccion_empuje = (body.global_position - global_position).normalized()
		body.global_position += direccion_empuje * 50
