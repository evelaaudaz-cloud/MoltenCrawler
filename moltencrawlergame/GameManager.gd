extends Node

var nivel_actual = 1
var generadores_activados = 0
var generadores_totales_en_nivel = 0
var escena_donde_murio : String = "" 

func registrar_generador():
	# Mantenemos el candado de 3 para tu generación actual
	if generadores_totales_en_nivel < 3:
		generadores_totales_en_nivel += 1
		print("Generador registrado. Total: ", generadores_totales_en_nivel)
	else:
		print("Registro bloqueado: Límite de 3 alcanzado.")

func generador_completado():
	generadores_activados += 1
	print("Progreso: ", generadores_activados, "/", generadores_totales_en_nivel)
	
	if generadores_activados >= generadores_totales_en_nivel:
		completar_nivel()

func reset_progreso():
	generadores_activados = 0
	generadores_totales_en_nivel = 0
	print("GameManager: Contadores reiniciados.")

func completar_nivel():
	nivel_actual += 1
	# No reseteamos aquí, el Generador llamará a reset_progreso al empezar el siguiente
	if get_node_or_null("/root/Transicion"):
		get_node("/root/Transicion").jugar_transicion_salida()
	
	get_tree().change_scene_to_file("res://Refugio.tscn")

# --- ESTA ES LA FUNCIÓN QUE FALTABA ---
func jugador_murio(ruta_escena_actual):
	print("El jugador ha muerto en: ", ruta_escena_actual)
	escena_donde_murio = ruta_escena_actual
	reset_progreso() # Limpiamos para que al reintentar no haya errores
	get_tree().change_scene_to_file("res://GameOver.tscn")
