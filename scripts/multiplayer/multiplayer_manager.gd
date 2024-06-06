extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var multiplayer_player = preload("res://scenes/multiplayer/multiplayer_player.tscn")

var _players_spawn_node

func become_host():
	print("Starting Host")
	
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	_remove_single_player()
	
	_add_player_to_game(1)

func join_game():
	print("Player Joining")
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer
	_remove_single_player()

func _add_player_to_game(netid: int):
	print("Player %s joined the game!" % netid)
	
	var player_to_add = multiplayer_player.instantiate()
	player_to_add.player_id = netid
	player_to_add.name = str(netid)
	
	_players_spawn_node.add_child(player_to_add, true)
	
func _del_player(netid: int):
	print("Player %s left the game!" % netid)
	if not _players_spawn_node.has_node(str(netid)):
		return
	_players_spawn_node.get_node(str(netid)).queue_free()
	
func _remove_single_player():
	print("Remove single player")
	var player_to_remove = get_tree().get_current_scene().get_node("Player")
	player_to_remove.queue_free()
