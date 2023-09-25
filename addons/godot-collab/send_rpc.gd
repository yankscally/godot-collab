@tool
extends EditorPlugin
var node = null
var main = null
var mpapi = null

func send_list(script_list):
	if mpapi == null:
		if main.is_server == true:
			mpapi = main.server.mpapi
		else:
			mpapi = main.client.mpapi
	var list = {}
	for each in script_list:
		list[each] = script_list[each].source_code
	if node == null:
		node = Node.new()
		node.set_meta("mpapi", mpapi)
		node.set_script(load("res://addons/godot-collab/rpc.gd"))
		node.name = "godotcolabpluginmp"
		get_editor_interface().get_base_control().add_child(node)
		mpapi.set_root_path(node.get_path())
	for each in mpapi.get_peers():
		mpapi.rpc(each, node, "get_scriptlist", [list, main.get_path()])



