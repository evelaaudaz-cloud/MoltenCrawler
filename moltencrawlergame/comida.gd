extends Area2D

func _on_body_entered(body):
	if body.name == "Molten":
		body.salud_actual = body.salud_maxima # Lo cura todo
		queue_free() # La lata desaparece
