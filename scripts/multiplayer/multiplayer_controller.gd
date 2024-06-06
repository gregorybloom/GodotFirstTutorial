extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

@onready var animated_sprite_2d = $AnimatedSprite2D


@export var player_id := 1:
	set(id):
		player_id = id
		# grants client-side authority (the ability to set the replicated variables) for the input control 
		%InputSynchronizer.set_multiplayer_authority(id)

func _apply_animations(delta):
	# Get the input direction: -1, 0, 1
#	var direction = Input.get_axis("ui_left", "ui_right")
#	direction = Input.get_axis("move_left", "move_right")

	# Flip the Sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	
	
func _apply_movement_from_input(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	direction = %InputSynchronizer.input_direction

	# Apply movement	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _physics_process(delta):
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
