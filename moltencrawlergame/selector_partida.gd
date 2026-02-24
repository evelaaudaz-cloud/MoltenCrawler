extends Control

func _on_nuevo_pressed() -> void:
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		DirAccess.remove_absolute(SaveManager.SAVE_PATH)
	
	GameManager.nivel_actual = 1
	GameManager.reset_progreso()
	get_tree().change_scene_to_file("res://Refugio.tscn")
	
func _on_continuar_pressed():
	if SaveManager.cargar_partida():
		GameManager.nivel_actual = SaveManager.datos_guardados["nivel_desbloqueado"]
		get_tree().change_scene_to_file("res://Refugio.tscn")
	else:
		_on_nuevo_pressed()
