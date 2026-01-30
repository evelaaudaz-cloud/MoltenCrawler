extends Node2D

func _ready():
	# Conectamos la señal de Molten con la barra de vida
	$Molten.salud_cambiada.connect(_on_molten_salud_cambiada)

func _on_molten_salud_cambiada(nueva_salud):
	$HUD/ProgressBar.value = nueva_salud
