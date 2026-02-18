extends Area2D

@onready var cartel = $Label 

func _ready():
	cartel.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		cartel.visible = true 

func _on_body_exited(body):
	if body.is_in_group("jugador"):
		cartel.visible = false 

func _input(event):
	if cartel.visible and event.is_action_pressed("interactuar"):
		hacer_guardado()

func hacer_guardado():
	SaveManager.guardar_partida(GameManager.nivel_actual)
	
	cartel.text = "¡Progreso Guardado!"
	cartel.modulate = Color.GREEN
	
	await get_tree().create_timer(2.0).timeout
	cartel.text = "[E] Dormir y Guardar"
	cartel.modulate = Color.WHITE
