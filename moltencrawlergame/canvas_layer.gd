extends CanvasLayer

@onready var texto_label = $TextureRect/TextureDialogo
@onready var indicador = $TextureRect/IndicadorEspacio
@onready var timer = $TimerEscritura
@onready var glotch = $TextureRect/Sprite2D/AnimationPlayer

var lineas_tutorial = [
	"[???]: Hey tu, ¿Ya despertaste?",
	"[???]: Menos mal, me temía que murieras",
	"[???]: No vayas a entrar en la caldera aún si quieres mantenerte así",
	"[YEKATERINA]: Mi nombre es Yekaterina, dueña del Navy Park",
	"[YEKATERINA]: Puedes moverte haciendo click a donde quieras ir, pero aun no",
	"[YEKATERINA]: Esta fosa de percebes esta plagada de esas cosas...",
	"[YEKATERINA]: Le temen a la luz, tendrás que enfrentarlos",
	"[YEKATERINA]: Se a quien estas buscando, y por el momento no puedo ayudarte",
	"[YEKATERINA]: Necesito que bajes a la caldera y pongas madera en los hornos",
	"[YEKATERINA]: Encontrarás leños, a tientas, en la obscuridad",
	"[YEKATERINA]: Oh, y, cuidado con el agua, es toxica",
	"[YEKATERINA]: Poseidon sabe cuanto tiempo ha estado estancada",
	"[YEKATERINA]: Eso si, la comida del parque es muy resistente",
	"[YEKATERINA]: Debe haber algo que puedas comer por ahi",
	"[YEKATERINA]: Por ultimo, no querras olvidar todo lo que haz hecho",
	"[YEKATERINA]: Aqui en el refugio hay una cama para que descanses",
	"[YEKATERINA]: Diría alguna mariscada como que 'creo en ti'",
	"[YEKATERINA]: Pero se que te costará una vida",
	"[YEKATERINA]: Mucha suerte, Molten"
]

var indice = 0
var escribiendo = false
@onready var glitch = $AnimationPlayer

func _ready():
	glitch.play("glitch")
	glotch.play("idle")
	if GameManager.nivel_actual == 1:
		iniciar_dialogo()
	else:
		self.hide() 

func iniciar_dialogo():
	self.show()
	mostrar_linea()

func _input(event):
	if self.visible and event.is_action_pressed("ui_accept"): 
		if escribiendo:
			saltar_animacion()
		else:
			proxima_linea()

func mostrar_linea():
	if indice < lineas_tutorial.size():
		escribiendo = true 
		texto_label.text = lineas_tutorial[indice]
		texto_label.visible_characters = 0
		timer.start()
	else:
		finalizar_dialogo()

func _on_timer_escritura_timeout():
	if texto_label.visible_characters < texto_label.text.length():
		texto_label.visible_characters += 1
	else:
		completar_linea()

func completar_linea():
	escribiendo = false
	timer.stop()
	indicador.show() 

func saltar_animacion():
	texto_label.visible_characters = texto_label.text.length()
	completar_linea()

func proxima_linea():
	indice += 1
	mostrar_linea()

func finalizar_dialogo():
	var tween = create_tween()
	tween.tween_property(self, "offset:y", 200, 0.5) 
	await tween.finished
	self.hide()
