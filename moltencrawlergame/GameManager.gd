# GameManager.gd (Autoload)
extends Node

var nivel_actual = 1
var generadores_activados = 0
var generadores_totales_en_nivel = 0
var escena_donde_murio : String = "" # Movida arriba con las demás

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
		
func reset_progreso():
	generadores_activados = 0
	generadores_totales_en_nivel = 0
	print("Reiniciado")

func completar_nivel():
	nivel_actual += 1
	reset_progreso() # Usamos tu función de reset para limpiar todo
	
	if get_node_or_null("/root/Transicion"):
		Transicion.jugar_transicion_salida()
	
	# Nota: Si el Autoload de Transicion cambia la escena, 
	# quizás quieras quitar el change_scene de aquí para que no choquen.
	get_tree().change_scene_to_file("res://Refugio.tscn")

func jugador_murio(ruta_escena_actual):
	escena_donde_murio = ruta_escena_actual
	reset_progreso()
	get_tree().change_scene_to_file("res://GameOver.tscn")
