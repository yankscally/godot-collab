extends EditorPlugin

var SERVER_IP = null
var SERVER_PORT = null
var is_loaded = false
var mpapi = null
var id
var status = -1
var MAX_PLAYERS = 100
var host = null
var node = null
var connected_users = {}
var timer
## custom mp api node root fix
func add_node(tool):
	if node != null:
		if node.name in get_editor_interface().get_base_control().get_children():
			node.queue_free()
	else:
		if "godotcolabpluginmp" in get_editor_interface().get_base_control().get_children():
			get_editor_interface().get_base_control().get_node("godotcolabpluginmp").queue_free()
	node = Node.new()
	node.set_meta("tool", tool)
	node.set_script(load("res://addons/godot-collab/rpc.gd"))
	node.name = "godotcolabpluginmp"
	get_editor_interface().get_base_control().add_child(node)
	mpapi.set_root_path(node.get_path())

###
func _load(ip,port,is_server,tool):
	mpapi = MultiplayerAPI.create_default_interface()
	is_loaded = true
	SERVER_PORT = int(port)
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
	add_node(tool)
	connected_users = {}
	if node != null and is_server == true:
		var beat = node.get_node_or_null("HeartBeat")
		if beat != null:
			beat.queue_free()
		timer = Timer.new()
		timer.name = "HeartBeat"
		timer.wait_time = 2.0
		timer.connect("timeout", heartbeat)
		timer.set_one_shot(false)
		timer.set_timer_process_callback(1)
		timer.set_one_shot(true)
		timer.set_autostart(true)
		node.add_child(timer)
#####  client
func connect_to_server():
	if host != null:
		host = null
	host = ENetMultiplayerPeer.new()
	host.create_client(SERVER_IP, SERVER_PORT)
	mpapi.set_multiplayer_peer(host)
	id = mpapi.get_unique_id()

func _client_connected():
	print("Connected OK!")
	status = 2

func _client_disconnected():
	print("Sever Disconnected")
	status = 0
	timer.set_paused(true)
	print("timer paused")

##### server
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

func _editor_connected(id):
	print("Editor Connected: " + str(id))
	connected_users[str(id)] = {
		"name": "Unknown",
		"Colour": "",
	}
	if timer.is_stopped() == true:
		timer.start()
	elif timer.is_paused() == true:
		timer.set_paused(false)

func _editor_disconnected(id):
	print("Editor Disconnected "  + str(id))
	connected_users.erase(str(id))
	if len(connected_users) <= 0:
		timer.set_paused(true)
		print("timer paused")

func heartbeat():
	if len(connected_users) > 0:
		for user in connected_users:
			connected_users[user]["beat"] = Time.get_ticks_msec()
			if connected_users[user]["name"] == "Unknown":
				mpapi.rpc(int(user), node, "request_user_info")
			mpapi.rpc(int(user), node, "repeater")
	if timer.is_stopped() == true:
		timer.start()
	elif timer.is_paused() == true:
		timer.set_paused(false)
