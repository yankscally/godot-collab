extends RefCounted

var SERVER_PORT = null
var MAX_PLAYERS = 100
var is_loaded = false
var host = null
var mpapi = null

func _load(port):
	is_loaded = true
	SERVER_PORT = port
	mpapi.peer_connected.connect(_player_connected)
	mpapi.peer_disconnected.connect(_player_disconnected)
	create_server()

func create_server():
	if host != null:
		host = null
		mpapi.set_multiplayer_peer(null)
	host = ENetMultiplayerPeer.new()
	host.create_server(SERVER_PORT, MAX_PLAYERS)
	# Optional DTLS is now moved the ENetConnection interface.
	#host.get_host().dtls_server_setup(
	#	load("res://priv.key"),
	#	load("res://cert.crt")
	#)
	mpapi.set_multiplayer_peer(host)
	print("server started on: ")


func _player_connected(id):
	print("Player connected: " + str(id))


func _player_disconnected(id):
	print("Player Disconnected "  + str(id))
