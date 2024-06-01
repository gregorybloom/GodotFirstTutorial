extends Area2D


@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	var game_manager = get_node("/root/GameManager")
	
	game_manager.add_point()
	animation_player.play("pickup")

