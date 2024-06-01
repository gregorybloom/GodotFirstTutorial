extends Control



func become_host():
	print("become host pressed")
	MultiplayerManager.become_host()
	hide()
	
func join_game():
	print("Join as player 2")
	MultiplayerManager.join_game()
	hide()
