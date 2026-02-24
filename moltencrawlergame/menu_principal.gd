extends Control

@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("idle")
	$VBoxContainer/BotonJugar.pressed.connect(_on_jugar_pressed)
	$VBoxContainer/BotonSalir.pressed.connect(_on_salir_pressed)
	
	$VBoxContainer/BotonJugar.grab_focus()

func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://selector_partida.tscn")

func _on_salir_pressed():
	get_tree().quit()
