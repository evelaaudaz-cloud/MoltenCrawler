# GameManager.gd (Autoload)
extends Node

var nivel_actual = 1
var generadores_activados = 0
var generadores_totales_en_nivel = 0

# Esta función la llamará cada generador al aparecer (en su _ready)
func registrar_generador():
	generadores_totales_en_nivel += 1
	print("Generador registrado. Total en este nivel: ", generadores_totales_en_nivel)

func generador_completado():
	generadores_activados += 1
	print("Progreso: ", generadores_activados, "/", generadores_totales_en_nivel)
	
	if generadores_activados >= generadores_totales_en_nivel:
		completar_nivel()
	else:
		print("Generador activado... Faltan " + str(generadores_totales_en_nivel - generadores_activados))

func completar_nivel():
	nivel_actual += 1
	# Resetear conteos para el próximo nivel
	generadores_activados = 0
	generadores_totales_en_nivel = 0 
	if Transicion:
		Transicion.jugar_transicion_salida()
	
	# Esperar un poco para que el jugador vea el mensaje y respire
	get_tree().change_scene_to_file("res://Refugio.tscn")
