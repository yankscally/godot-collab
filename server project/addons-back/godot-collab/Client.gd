extends Node

var SERVER_IP = null
var SERVER_PORT = null
var client = null
var is_loaded = false
var mpapi = null
var id
var status = -1
var editor = null

func _load(ip,port):
	is_loaded = true
	SERVER_IP = str(ip)
	SERVER_PORT = int(port)
	mpapi.connected_to_server.connect(_connected_ok)
	mpapi.connection_failed.connect(_connected_fail)
	mpapi.server_disconnected.connect(_server_disconnected)
	connect_to_server()

func connect_to_server():
	if client != null:
		client = null
	client = ENetMultiplayerPeer.new()
	client.create_client(SERVER_IP, SERVER_PORT)
	mpapi.set_multiplayer_peer(client)
	id = mpapi.get_unique_id()

func _connected_ok():
	print("Connected OK!")
	status = 2

func _server_disconnected():
	print("Sever Disconnected")
	status = 0

func _connected_fail():
	print("Connection Failed")
	status = 1


