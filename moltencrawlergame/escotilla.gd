extends Area2D

@export var send_to_scene = "res://Mazmorra.tscn"
@onready var label = $Label
@onready var anim_player = $AnimationPlayer

func _ready():
	# Conectamos las señales del ratón para el texto
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	# Conectamos la señal de llegada de Molten
	body_entered.connect(_on_body_entered)

func _on_mouse_entered():
	label.show() # Muestra el texto cuando el cursor entra

func _on_mouse_exited():
	label.hide() # Oculta el texto cuando el cursor sale

func _on_body_entered(body):
	if body.name == "Molten":
		# Bloqueamos el movimiento de Molten para que no siga caminando
		body.set_physics_process(false)
		
		# Iniciamos el fade out
		anim_player.play("fade_out")
		
		# Esperamos a que la animación termine antes de cambiar de escena
		await anim_player.animation_finished
		
		get_tree().change_scene_to_file(send_to_scene)
