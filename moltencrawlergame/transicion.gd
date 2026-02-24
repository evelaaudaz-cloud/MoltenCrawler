extends CanvasLayer

@onready var anim = $AnimationPlayer
@onready var label = $TextoClear 
@onready var fondo = $Fondo

func _ready():
	hide()

func jugar_transicion_salida():
	show() 
	
	if anim == null:
		print("ERROR: No encontré el AnimationPlayer. Revisa el nombre del nodo.")
		return
	anim.play("nivel_completado")
	await get_tree().create_timer(3.0).timeout
	hide()
	get_tree().call_deferred("change_scene_to_file", "res://Refugio.tscn")
