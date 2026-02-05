# GameOver.gd
extends CanvasLayer

func _on_boton_reintentar_pressed():
	# Usamos la variable que guardamos en tu GameManager
	if GameManager.escena_donde_murio != "":
		get_tree().change_scene_to_file(GameManager.escena_donde_murio)

func _on_boton_menu_pressed():
	# Te lleva al inicio (ajusta la ruta a tu menú principal)
	get_tree().change_scene_to_file("res://Refugio.tscn")
