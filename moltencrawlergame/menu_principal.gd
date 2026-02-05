extends Control

func _ready():
	# Conectamos los botones
	$VBoxContainer/BotonJugar.pressed.connect(_on_jugar_pressed)
	$VBoxContainer/BotonSalir.pressed.connect(_on_salir_pressed)
	
	# Opcional: Que el botón de jugar esté seleccionado para usar teclado/mando
	$VBoxContainer/BotonJugar.grab_focus()

func _on_jugar_pressed():
	# Por ahora, vamos directo al Nivel 1
	# Más adelante aquí podrías poner la selección de personajes o niveles
	get_tree().change_scene_to_file("res://Nivel1.tscn")

func _on_salir_pressed():
	# Cerramos el juego
	get_tree().quit()
