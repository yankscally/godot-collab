@tool
extends EditorPlugin
var started = false
var dock = preload("res://addons/godot-collab/godot_collab_ui.tscn").instantiate()
var editor = preload("res://addons/godot-collab/EditorSync.gd").new()
var server = preload("res://addons/godot-collab/Server.gd").new()
var client = preload("res://addons/godot-collab/Client.gd").new()
var data_send = preload("res://addons/godot-collab/send_rpc.gd").new()
var mpapi = MultiplayerAPI.create_default_interface()
var is_server = false
var ip = "127.0.0.1"
var port = 10567
var username = "default"

func _ready():
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	dock.colab_tool = self
	editor.send = data_send
	client.editor = editor
	data_send.main = self
	data_send.mpapi = mpapi

func dock_start(_server,_ip,_port,_user,_started):
	if _started == true:
		if _server != false:
			if _ip != "":
				ip = _ip
		is_server = _server
		if _port != "":
			port = _port
		if _user != "":
			username = _user
		started = true
		
	else:
		stop_running()
		
func stop_running():
	started = false
	server.is_loaded = false
	server.mpapi = null
	server.host = null
	client.is_loaded = false
	client.mpapi = null
	client.client = null

func _process(delta):
	if started == true:
		if is_server == true:
			if server.is_loaded == false:
				server.mpapi = mpapi
				server._load(port)
			mpapi.poll()
			#if len(server.mpapi.get_peers()) > 0:
			editor.script_loop()
		else:
			if client.is_loaded == false:
				client.mpapi = mpapi
				client._load(ip,port)
			mpapi.poll()
			if client.status == 2:
				editor.script_loop()

