extends Node2D

func _ready():
	$Molten.salud_cambiada.connect(_on_molten_salud_cambiada)

func _on_molten_salud_cambiada(nueva_salud):
	$HUD/ProgressBar.value = nueva_salud

var tiempo_escape = 0.0

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		tiempo_escape += delta
		
		if tiempo_escape >= 3.0:
			get_tree().quit()
	else:
		tiempo_escape = 0.0
