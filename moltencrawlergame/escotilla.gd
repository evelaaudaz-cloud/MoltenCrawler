extends Area2D

# Ya no necesitamos send_to_scene fija, la calcularemos
@onready var label = $Label
@onready var anim_player = $AnimationPlayer

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	body_entered.connect(_on_body_entered)
	label.text = "Bajar a la Planta " + str(GameManager.nivel_actual)

func _on_mouse_entered():
	label.text = "Entrar al Nivel " + str(GameManager.nivel_actual)
	label.show()

func _on_mouse_exited():
	label.hide()

func _on_body_entered(body):
	if body.name == "Molten":
		body.set_physics_process(false)
		
		# Construimos la ruta dinámicamente
		# Esto asume que tus escenas se llaman Nivel1.tscn, Nivel2.tscn, etc.
		var ruta_nivel = "res://Niveles/Nivel" + str(GameManager.nivel_actual) + ".tscn"
		
		anim_player.play("fade_out")
		await anim_player.animation_finished
		
		# Cambiamos al nivel correspondiente
		get_tree().change_scene_to_file(ruta_nivel)
