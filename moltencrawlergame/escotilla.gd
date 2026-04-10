extends Area2D

@onready var label = $Label
@onready var anim_player = $AnimationPlayer

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	body_entered.connect(_on_body_entered)
	
	label.text = "Bajar a la Planta " + str(int(GameManager.nivel_actual))
	label.hide() 

func _on_mouse_entered():
	label.text = "Entrar al Nivel " + str(int(GameManager.nivel_actual))
	label.show()

func _on_mouse_exited():
	label.hide()

func _on_body_entered(body):
	if body.name == "Molten" or body.is_in_group("jugador"):
		body.set_physics_process(false)
		
		# ¡CAMBIO CLAVE AQUÍ!
		# Ya no buscamos Nivel1, Nivel2. Siempre vamos al mapa procedural.
		var ruta_nivel = "res://NivelProcedural.tscn" 
		
		print("Generando nuevo nivel procedural...")
		
		if anim_player.has_animation("fade_out"):
			anim_player.play("fade_out")
			await anim_player.animation_finished
		
		var error = get_tree().change_scene_to_file(ruta_nivel)
		
		if error != OK:
			print("Error: No se encontró la escena maestra en ", ruta_nivel)
