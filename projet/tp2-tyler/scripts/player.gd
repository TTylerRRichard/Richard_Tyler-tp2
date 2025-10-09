extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer2D = $jump
@onready var run: AudioStreamPlayer = $run
@onready var collision_shape_2d = $CollisionShape2D

func use_power_up():
	var powerUpDuration = 5
	
	AnimatedSprite2D.scale *= 2
	AnimatedSprite2D.position.y *= 2
	CollisionShape2D.scale *= 2
	CollisionShape2D.position.y *= 2
	await get_tree().create_timer(powerUpDuration).timeout
	
	AnimatedSprite2D.scale /=2
	AnimatedSprite2D.position.y /= 2
	CollisionShape2D.scale /=2
	CollisionShape2D.position.y /=2
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump.play()
		
	# Get the input direction: -1 (left), 0 (none), 1 (right)
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	
	if is_on_floor() and direction != 0:
		if not run.playing:
			run.play()
	else:
		if run.playing:
			run.stop()
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
