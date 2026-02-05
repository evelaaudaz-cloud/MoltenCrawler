extends Control

@onready var video = $VideoStreamPlayer

func _ready():
	if video.stream == null:
		print("¡ERROR: No hay ningún vídeo cargado en el nodo!")
	else:
		print("Vídeo detectado, intentando reproducir: ", video.stream.resource_path)
		video.play()

func _process(_delta):
	if video.is_playing():
		# Esto imprimirá el segundo actual del vídeo
		# print("Reproduciendo... ", video.stream_position)
		pass
