extends CanvasLayer

func _on_boton_reintentar_pressed():
	if GameManager.escena_donde_murio != "":
		get_tree().change_scene_to_file(GameManager.escena_donde_murio)

func _on_boton_menu_pressed():
	get_tree().change_scene_to_file("res://Refugio.tscn")
