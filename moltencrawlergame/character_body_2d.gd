extends CharacterBody2D

@export var speed = 250.0
@onready var sprite = $Sprite2D            # Referencia al dibujo
@onready var anim_player = $AnimationPlayer # Referencia al animador

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "up", "down")
	
	if direction:
		velocity = direction * speed
		update_animation(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		anim_player.play("idle")

	move_and_slide()

func update_animation(dir):
	# Prioridad al movimiento horizontal
	if abs(dir.x) > abs(dir.y):
		anim_player.play("walk_side")
		# Aquí volteamos el Sprite2D directamente
		sprite.flip_h = dir.x < 0 
	else:
		if dir.y > 0:
			anim_player.play("walk_down")
		else:
			anim_player.play("walk_up")
