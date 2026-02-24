extends StaticBody2D

func _ready():
	$ZonaSegura.body_entered.connect(_on_zona_segura_body_entered)
	$ZonaSegura.body_exited.connect(_on_zona_segura_body_exited)

func _on_zona_segura_body_entered(body):
	if body.has_method("reaccionar_a_luz"):
		body.reaccionar_a_luz(true, global_position)

func _on_zona_segura_body_exited(body):
	if body.has_method("reaccionar_a_luz"):
		body.reaccionar_a_luz(false, global_position)
