extends CanvasLayer

@onready var anim = $AnimationPlayer
@onready var label = $TextoClear # Asegúrate que el nombre coincida
@onready var fondo = $Fondo

func _ready():
	# Empezamos invisibles para que no tape el menú inicial
	hide()

func jugar_transicion_salida():
	show() # Hacemos visible el CanvasLayer
	
	if anim == null:
		print("ERROR: No encontré el AnimationPlayer. Revisa el nombre del nodo.")
		return

	# Reproducimos la animación que creamos en el editor
	anim.play("nivel_completado")
	await get_tree().create_timer(3.0).timeout
	hide()
	
	# La animación debe durar unos 3 segundos
	# Justo a la mitad (cuando está todo negro), cambiamos la escena
	get_tree().call_deferred("change_scene_to_file", "res://Refugio.tscn")
