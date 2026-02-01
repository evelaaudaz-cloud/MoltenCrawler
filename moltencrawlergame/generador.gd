extends Area2D

var activado = false

func _ready():
	GameManager.registrar_generador()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador") and not activado:
		if body.llaves > 0:
			body.usar_llave() # Restamos una llave al jugador
			activar()
		else:
			# Aquí podrías poner un mensaje de "Necesitas una llave"
			print("¡Sin llave no hay energía!")

func activar():
	activado = true
	$PointLight2D.enabled = true
	$Sprite2D.modulate = Color.GREEN
	
	# Avisamos al GameManager (lo creamos abajo)
	GameManager.generador_completado()
