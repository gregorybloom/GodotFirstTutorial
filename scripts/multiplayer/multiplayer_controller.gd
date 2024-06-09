extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var do_jump = false
var _is_on_floor = true
var alive = true

@onready var animated_sprite_2d = $AnimatedSprite2D


@export var player_id := 1:
	set(id):
		player_id = id
		# grants client-side authority (the ability to set the replicated variables) for the input control 
		%InputSynchronizer.set_multiplayer_authority(id)

func _ready():
	# is this local player?
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false

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
	if _is_on_floor:
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
	if do_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		do_jump = false

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
		if not alive && is_on_floor():
			_set_alive()
			
		_is_on_floor = is_on_floor()
		_apply_movement_from_input(delta)

	if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
		_apply_animations(delta)

func mark_dead():
	print("Mark player dead!")
	position = MultiplayerManager.respawn_point
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$RespawnTimer.start()
	
func _respawn():
	print("Respawned!")	

	position = MultiplayerManager.respawn_point
	$CollisionShape2D.set_deferred("disabled", false)

func _set_alive():
	print("Alive again!")
	alive = true
	Engine.time_scale = 1.0
