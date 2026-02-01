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
		enviar_mensaje("Generador activado... Faltan " + str(generadores_totales_en_nivel - generadores_activados))

func completar_nivel():
	nivel_actual += 1
	# Resetear conteos para el próximo nivel
	generadores_activados = 0
	generadores_totales_en_nivel = 0 
	
	enviar_mensaje("¡Sistemas online! Regresando al refugio...")
	
	# Esperar un poco para que el jugador vea el mensaje y respire
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Refugio.tscn")

func enviar_mensaje(texto: String):
	var interfaz = get_tree().current_scene.find_child("Mensaje", true, false)
	if interfaz and interfaz.has_method("mostrar_texto"):
		interfaz.mostrar_texto(texto)
