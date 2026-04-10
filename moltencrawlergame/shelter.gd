extends Node2D

# Esto creará una casilla en el panel de la derecha (Inspector)
@export var jugador: Node2D 

func _ready():
	# Te aseguras de que el jugador exista antes de conectar
	if jugador:
		jugador.salud_cambiada.connect(_on_molten_salud_cambiada)
	else:
		print("¡Se te olvidó arrastrar a Molten al inspector!")
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
