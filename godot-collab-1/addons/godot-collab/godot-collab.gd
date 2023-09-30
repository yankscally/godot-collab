@tool
extends EditorPlugin
var started = false
var dock = preload("res://addons/godot-collab/Dock/godot_collab_ui.tscn").instantiate()
var editor = preload("res://addons/godot-collab/ScriptEditor/EditorSync.gd").new()
var network = preload("res://addons/godot-collab/Network/Network.gd").new()
var is_server = false
var ip = "127.0.0.1"
var port = 10567
var username = "default"
var colour = ""
func _ready():
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	dock.colab_tool = self
	editor.colab_tool = self

func dock_start(_server,_ip,_port,_user,_colour,_started):
	## function is called from the dock UI 
	if _started == true:
		if _server != false:
			if _ip != "":
				ip = _ip
		is_server = _server
		if _port != "":
			port = _port
		if _user != "":
			username = _user
		colour = _colour
		started = true
	else:
		stop_running()
		
func stop_running():
	started = false
	network.is_loaded = false
	network.mpapi = null
	network.host = null
	for user in network.user_list:
		network.user_list[user].queue_free()

func _process(delta):
	## the dock ui toggles started
	if started == true:
		## process the network
		# we have to poll it manually
		if network.is_loaded == false:
			network._load(ip,port,is_server,self)
		network.mpapi.poll()
		editor._loop()

