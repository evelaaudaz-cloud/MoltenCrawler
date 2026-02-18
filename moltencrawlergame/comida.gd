extends Area2D

@export var cura_cantidad = 30

func _on_body_entered(body):
	if body.has_method("recibir_daño"): 
		body.salud_actual += cura_cantidad
		body.salud_actual = clamp(body.salud_actual, 0, body.salud_maxima)
		body.emit_signal("salud_cambiada", body.salud_actual)
		
		print("Molten comió. Salud actual: ", body.salud_actual)
		queue_free() 
