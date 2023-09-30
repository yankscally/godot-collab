@tool
extends EditorPlugin
var collab_tool
var SERVER_IP = null
var SERVER_PORT = null
var is_loaded = false
var mpapi = null
var id
var status = -1
var MAX_PLAYERS = 100
var host = null
var node = null
var client = preload("res://addons/godot-collab/Network/client.tscn")
var user_pak = preload("res://addons/godot-collab/Network/Users.tscn")
var connected_users 
var user_list = {}
var timer
var lat = 0


func spawn_user(id):
	var new_client = client.instantiate()
	new_client.peer_id = id
	new_client.collab_tool = collab_tool
	user_list[str(id)] = new_client
	connected_users.spawn_user(new_client)

## custom mp api node root fix
func add_node(tool):
	collab_tool = tool
	if node != null:
		if node in get_editor_interface().get_base_control().get_children():
			node.queue_free()
	else:
		for each in get_editor_interface().get_base_control().get_children():
			if each.name == "godotcolabpluginmp":
				each.queue_free()
	node = Node.new()
	connected_users = user_pak.instantiate()
	node.set_meta("tool", tool)
	node.set_script(load("res://addons/godot-collab/rpc.gd"))
	node.name = "godotcolabpluginmp"
	get_editor_interface().get_base_control().add_child(node)
	mpapi.set_root_path(node.get_path())
	node.add_child(connected_users)

###
func _load(ip,port,is_server,tool):
	mpapi = MultiplayerAPI.create_default_interface()
	is_loaded = true
	SERVER_PORT = int(port)
	add_node(tool)
	if is_server == false:
		SERVER_IP = str(ip)
		mpapi.connected_to_server.connect(_client_connected)
		mpapi.connection_failed.connect(_client_disconnected)
		mpapi.server_disconnected.connect(_client_disconnected)
		connect_to_server()
	else:
		mpapi.peer_connected.connect(_editor_connected)
		mpapi.peer_disconnected.connect(_editor_disconnected)
		create_server()
		_editor_connected(1)

#####  client
func connect_to_server():
	if host != null:
		host = null
	host = ENetMultiplayerPeer.new()
	host.create_client(SERVER_IP, SERVER_PORT)
	mpapi.set_multiplayer_peer(host)

func _client_connected():
	print("Connected OK!")
	status = 2
	id = mpapi.get_unique_id()
	spawn_user(id)

func _client_disconnected():
	print("Sever Disconnected")
	status = 0

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
	print("server started")
	id = mpapi.get_unique_id()

func _editor_connected(id):
	print("Editor Connected: " + str(id))
	spawn_user(id)

func _editor_disconnected(id):
	print("Editor Disconnected "  + str(id))
	if str(id) in user_list:
		user_list[str(id)].queue_free()
