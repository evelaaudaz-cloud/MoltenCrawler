extends Area2D

# Referencia al Label que creamos
@onready var cartel = $Label 

func _ready():
	# Nos aseguramos de que el cartel esté oculto al empezar
	cartel.visible = false
	# Conectamos las señales de entrada y salida del área
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		cartel.visible = true # Mostramos el cartel cuando Molten se acerca

func _on_body_exited(body):
	if body.is_in_group("jugador"):
		cartel.visible = false # Lo ocultamos cuando se aleja

func _input(event):
	# Si el cartel es visible (Molten está cerca) y presiona E
	if cartel.visible and event.is_action_pressed("interactuar"):
		hacer_guardado()

func hacer_guardado():
	# Usamos la lógica que ya tenemos en el SaveManager
	SaveManager.guardar_partida(GameManager.nivel_actual)
	
	# Efecto visual de confirmación: el texto cambia un momento
	cartel.text = "¡Progreso Guardado!"
	cartel.modulate = Color.GREEN
	
	# Esperamos 2 segundos y volvemos a la normalidad
	await get_tree().create_timer(2.0).timeout
	cartel.text = "[E] Dormir y Guardar"
	cartel.modulate = Color.WHITE
