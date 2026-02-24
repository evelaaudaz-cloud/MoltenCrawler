extends Node

const SAVE_PATH = "user://molten_save.dat"

var datos_guardados = {
	"escena_actual": "res://Refugio.tscn",
	"nivel_desbloqueado": 1,
	"salud_max": 100
}

func guardar_partida(numero_nivel):
	datos_guardados["nivel_desbloqueado"] = numero_nivel
	
	var archivo = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if archivo:
		var json_string = JSON.stringify(datos_guardados)
		archivo.store_line(json_string)
		archivo.close()
		print("Progreso guardado: Nivel ", numero_nivel)

func cargar_partida():
	if not FileAccess.file_exists(SAVE_PATH):
		return false
		
	var archivo = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if archivo:
		var json_string = archivo.get_line()
		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			datos_guardados = json.data
			return true
	return false
