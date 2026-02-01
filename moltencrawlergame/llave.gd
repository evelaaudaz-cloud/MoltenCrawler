extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		# Le damos la llave al jugador (necesitas crear esta variable en Molten)
		if body.has_method("obtener_llave"):
			body.obtener_llave()
			queue_free() # La llave desaparece
