extends Control

@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("idle")
	# Conectamos los botones
	$VBoxContainer/BotonJugar.pressed.connect(_on_jugar_pressed)
	$VBoxContainer/BotonSalir.pressed.connect(_on_salir_pressed)
	
	# Opcional: Que el botón de jugar esté seleccionado para usar teclado/mando
	$VBoxContainer/BotonJugar.grab_focus()

func _on_jugar_pressed():
	# Por ahora, vamos directo al Nivel 1
	# Más adelante aquí podrías poner la selección de personajes o niveles
	get_tree().change_scene_to_file("res://selector_partida.tscn")

func _on_salir_pressed():
	# Cerramos el juego
	get_tree().quit()
