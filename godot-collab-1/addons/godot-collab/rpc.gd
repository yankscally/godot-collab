@tool
extends Node
var collab_tool

func _ready():
	collab_tool = get_meta("tool")

@rpc("any_peer", "reliable")
func transmit_edit_script(type, lines, path):
	collab_tool.editor.rpc_calls_change(type, lines, path)
#
#@rpc("any_peer", "reliable")
#func heartbeat(time):
#	var id = collab_tool.network.mpapi.get_remote_sender_id()
#	if id == 1:
#		collab_tool.network.mpapi.rpc(1, self, "heartbeats", [ time ])
#
#@rpc("any_peer", "reliable")
#func heartbeats(time):
#	var id = collab_tool.network.mpapi.get_remote_sender_id()
#	collab_tool.network.user_list[str(id)].heartbeat(time, id)
##	var editor = EditorPlugin.new()
#	script_editor = editor.get_editor_interface().get_script_editor().get_current_editor().get_base_editor()
#	#script_editor.connect("text_changed", update_script)
#	
#
#@rpc("any_peer", "unreliable")
#func get_scriptlist(scriptlist):
#	for each in scriptlist:
#		if not "addons" in each:
#			if not each in collab_tool.editor.script_list:
#				collab_tool.editor.script_list[each] = load(each)
##			collab_tool.editor.script_list[each].source_code = scriptlist[each]
##
##			script_source = scriptlist[each]
##			update_script(script_source)
##
##func update_script(input):
##		script_editor.set("text", input)
#
#
##### heart beats    Both these functions are to check clients latency in milliseconds
### updates source code of scripts based on last edit time 
### using current run time... and latency in the case of users
#@rpc("any_peer", "unreliable")
#func Script_updated(path, code, time):
#	print(path)
#	var id = collab_tool.network.mpapi.get_remote_sender_id()
#	if not "addons" in path:
#		if path in collab_tool.editor.script_list:
#			if not "last" in collab_tool.editor.script_list:
#					var script = load(str(path))
#					if script == null:
#						script = GDScript.new()
#					collab_tool.editor.script_list = {"obj": script, "last": 0}
#			if collab_tool.network.mpapi.is_server() == true:
#				if int(collab_tool.editor.script_list["last"]) < Time.get_ticks_msec() - collab_tool.network.connected_users[str(id)]["latency"]:
#					collab_tool.editor.script_list["obj"].source_code = code
#					collab_tool.editor.script_list["last"] = Time.get_ticks_msec()
#			else:
#				if int(collab_tool.editor.script_list["last"]) < collab_tool.network.lat:
#					collab_tool.editor.script_list["obj"].source_code = code
#					collab_tool.editor.script_list["last"] = time

##### heart beats    Both these functions are to check clients latency in milliseconds
### network.lat trys to keep server time to match with files
#@rpc("any_peer", "reliable")
#func repeater(_lat):
#	push_warning("heartbeat")
#	var id = collab_tool.network.mpapi.get_remote_sender_id()
#	if id == 1:
#		collab_tool.network.mpapi.rpc(1, self, "catcher")
#		if int(_lat) != -1:
#			collab_tool.network.lat = Time.get_ticks_msec() - float(_lat)
#@rpc("any_peer", "reliable")
#func catcher():
#	var id = collab_tool.network.mpapi.get_remote_sender_id()
#	var users = collab_tool.network.connected_users
#	if str(id) in users:
#		users[str(id)]["latency"] = float(Time.get_ticks_msec() - users[str(id)]["beat"])/2
#		push_warning(str(id), "  Latency: ", users[str(id)]["latency"], "ms")
##########################################################################################
#
##request users info to set name / colour
#@rpc("any_peer", "reliable")
#func request_user_info():
#	var id = collab_tool.network.mpapi.get_remote_sender_id()
#	if id == 1:
#		print("data requested")
#		collab_tool.network.mpapi.rpc(1, self, "provided_user_data", [collab_tool.username, collab_tool.colour])
#
#@rpc("any_peer", "reliable")
#func provided_user_data(_name, _colour):
#	var id = collab_tool.network.mpapi.get_remote_sender_id()
#	var users = collab_tool.network.connected_users
#	if str(id) in users:
#		users[str(id)]["name"] = _name
#		users[str(id)]["Colour"] = _colour
#		print(users)
#
#
################# role call
#
#@rpc("any_peer", "reliable")
#func announce_new_editor(user):
#	var users = collab_tool.network.connected_users
#	users[user["id"]] = user
#	print("EDITOR ARRIVED  ", users)
#
#@rpc("any_peer", "reliable")
#func announce_editor_gone(user):
#	var json = JSON.new()
#	user = json.parse(user)
#	var users = collab_tool.network.connected_users
#	for x in user:
#		if str(x) in users:
#			users.erase(x)
#			print("EDITOR GONE  ", users)
#		break
#
#@rpc("any_peer", "reliable")
#func provide_all_editors(users):
#	var json = JSON.new()
#	users = json.parse(str(users))
#	collab_tool.network.connected_users = users
