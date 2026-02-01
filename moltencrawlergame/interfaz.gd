extends CanvasLayer

@onready var label = $Mensaje

func _ready():
	# Nos aseguramos de que empiece totalmente transparente
	label.modulate.a = 0
	label.show() # Por si acaso estaba en 'hide'

func mostrar_texto(texto: String):
	label.text = texto
	
	# Matamos cualquier animación previa para que no choquen
	var tween = create_tween()
	
	# 1. Aparecer (0.5 segundos)
	tween.tween_property(label, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)
	# 2. Mantenerse (2 segundos)
	tween.tween_interval(2.0)
	# 3. Desaparecer (1 segundo)
	tween.tween_property(label, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE)
