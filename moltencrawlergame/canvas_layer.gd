extends CanvasLayer

@onready var texto_label = $TextureRect/TextureDialogo
@onready var indicador = $TextureRect/IndicadorEspacio
@onready var timer = $TimerEscritura

var lineas_tutorial = [
	"[???]: Hey tu, ¿Ya despertaste?",
	"[???]: Menos mal, me temía que murieras",
	"[???]: No vayas a entrar en la caldera aún \nsi quieres mantenerte así",
	"[YEKATERINA]: Mi nombre es Yekaterina, \ndueña del Nave Park",
	"[YEKATERINA]: Puedes moverte haciendo click \na donde quieras ir",
	"[YEKATERINA]: Esta mierda esta plagada de \nesas cosas...",
	"[YEKATERINA]: Le temen a la luz, tendrás que \nenfrentarlos",
	"[YEKATERINA]: Se a quien estas buscando, \ny por el momento no puedo ayudarte",
	"[YEKATERINA]: Necesito que bajes a la caldera \ny pongas madera en los hornos",
	"[YEKATERINA]: Encontrarás leños, a tientas, \nen la obscuridad",
	"[YEKATERINA]: Oh, y, cuidado con el agua, \nes toxica",
	"[YEKATERINA]: Poseidon sabe cuanto tiempo \nha estado estancada",
	"[YEKATERINA]: Eso si, la comida del parque \nes muy resistente",
	"[YEKATERINA]: Debe haber algo que puedas \ncomer por ahi",
	"[YEKATERINA]: Por ultimo, no querras olvidar \ntodo lo que haz hecho",
	"[YEKATERINA]: Aqui en el refugio hay una \ncama para que descanses",
	"[YEKATERINA]: Diría alguna bazofia como que \n'creo en ti'",
	"[YEKATERINA]: Pero se que te costará una vida",
	"[YEKATERINA]: Mucha suerte, Molten"
]

var indice = 0
var escribiendo = false

func _ready():
	# Solo mostramos el tutorial si es una partida nueva
	# (Puedes usar una variable en el GameManager para esto)
	if GameManager.nivel_actual == 1:
		iniciar_dialogo()
	else:
		self.hide() # Ocultar si ya es un jugador veterano

func iniciar_dialogo():
	self.show()
	mostrar_linea()

func _input(event):
	if self.visible and event.is_action_pressed("ui_accept"): # Tecla Espacio
		if escribiendo:
			saltar_animacion()
		else:
			proxima_linea()

func mostrar_linea():
	if indice < lineas_tutorial.size():
		escribiendo = true # Escondemos el "Presiona Espacio" mientras escribe
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
	indicador.show() # Mostramos que ya puede pasar a la siguiente

func saltar_animacion():
	texto_label.visible_characters = texto_label.text.length()
	completar_linea()

func proxima_linea():
	indice += 1
	mostrar_linea()

func finalizar_dialogo():
	# Hacemos un pequeño fade out o simplemente ocultamos
	var tween = create_tween()
	tween.tween_property(self, "offset:y", 200, 0.5) # Se desliza hacia abajo
	await tween.finished
	self.hide()
