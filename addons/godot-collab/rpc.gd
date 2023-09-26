@tool
extends Node
var collab_tool
var script_editor

var script_source 


func _ready():
	var editor = EditorPlugin.new()
	script_editor = editor.get_editor_interface().get_script_editor().get_current_editor().get_base_editor()
	#script_editor.connect("text_changed", update_script)
	collab_tool = get_meta("tool")

@rpc("any_peer", "unreliable")
func get_scriptlist(scriptlist):
	for each in scriptlist:
		if not "addons" in each:
			if not each in collab_tool.editor.script_list:
				collab_tool.editor.script_list[each] = load(each)
			collab_tool.editor.script_list[each].source_code = scriptlist[each]
			
			script_source = scriptlist[each]
			update_script(script_source)

func update_script(input):
		script_editor.set("text", input)



#### heart beats    Both these functions are to check clients latency in milliseconds
@rpc("any_peer", "reliable")
func repeater():
	push_warning("heartbeat")
	var id = collab_tool.network.mpapi.get_remote_sender_id()
	if id == 1:
		collab_tool.network.mpapi.rpc(1, self, "catcher")
@rpc("any_peer", "reliable")
func catcher():
	var id = collab_tool.network.mpapi.get_remote_sender_id()
	var users = collab_tool.network.connected_users
	if str(id) in users:
		users[str(id)]["latency"] = float(Time.get_ticks_msec() - users[str(id)]["beat"])/2
		push_warning(str(id), "  Latency: ", users[str(id)]["latency"], "ms")
#########################################################################################

#request users info to set name / colour
@rpc("any_peer", "reliable")
func request_user_info():
	var id = collab_tool.network.mpapi.get_remote_sender_id()
	if id == 1:
		print("data requested")
		collab_tool.network.mpapi.rpc(1, self, "provided_user_data", [collab_tool.username, collab_tool.colour])

@rpc("any_peer", "reliable")
func provided_user_data(_name, _colour):
	var id = collab_tool.network.mpapi.get_remote_sender_id()
	var users = collab_tool.network.connected_users
	if str(id) in users:
		users[str(id)]["name"] = _name
		users[str(id)]["Colour"] = _colour
		print(users)
