extends CharacterBody2D

@export var speed = 200.0
@export var current_skin = "base"

func _physics_process(_delta):
	# Obtenemos la dirección desde cualquier entrada (teclado o joystick)
	var direction = Input.get_vector("ui_left", "ui_right", "up", "down")
	
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
