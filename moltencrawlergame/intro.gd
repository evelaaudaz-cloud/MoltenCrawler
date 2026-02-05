extends Control

func _ready():
	# Cuando el vídeo termine solo, vamos al menú
	$VideoStreamPlayer.finished.connect(_al_terminar_video)

func _input(event):
	# Si presiona Escape o cualquier tecla de omitir
	if event.is_action_pressed("ui_cancel"): 
		_al_terminar_video()

func _on_boton_omitir_pressed():
	_al_terminar_video()

func _al_terminar_video():
	get_tree().change_scene_to_file("res://MenuPrincipal.tscn")
