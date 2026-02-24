extends Control

func _ready():
	$VideoStreamPlayer.finished.connect(_al_terminar_video)

func _input(event):
	if event.is_action_pressed("click"): 
		_al_terminar_video()

func _on_boton_omitir_pressed():
	_al_terminar_video()

func _al_terminar_video():
	get_tree().change_scene_to_file("res://MenuPrincipal.tscn")
