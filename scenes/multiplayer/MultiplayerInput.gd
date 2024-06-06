extends MultiplayerSynchronizer

var input_direction

# ** !! IMPORTANT - The Server Synchronizer must be before the Input Synchronizer in the scene tree or all hell breaks loose!

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		# only run these updates on the local client
		set_process(false)
		set_physics_process(false)
	
	input_direction = Input.get_axis("move_left", "move_right")



func _physics_process(delta):
	input_direction = Input.get_axis("move_left", "move_right")
	# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	pass
