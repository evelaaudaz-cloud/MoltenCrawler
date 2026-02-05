extends Control

func _on_nuevo_pressed() -> void:
	# Borramos archivo si existe y reseteamos el GameManager
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		DirAccess.remove_absolute(SaveManager.SAVE_PATH)
	
	GameManager.nivel_actual = 1
	GameManager.reset_progreso()
	get_tree().change_scene_to_file("res://Refugio.tscn")
	
func _on_continuar_pressed():
	if SaveManager.cargar_partida():
		# Le decimos al GameManager qué nivel le toca
		GameManager.nivel_actual = SaveManager.datos_guardados["nivel_desbloqueado"]
		# Siempre lo mandamos al Refugio, porque ahí fue donde guardó
		get_tree().change_scene_to_file("res://Refugio.tscn")
	else:
		# Si no hay partida, lo mandamos a nueva partida por defecto
		_on_nuevo_pressed()
