extends EditorPlugin
var colab_tool = null
var editor = null
var script_list = {}
var script_base = null

func script_loop():
	if editor == null:
		script_list = {}
		editor = get_editor_interface().get_script_editor()
		editor.connect("editor_script_changed", editor_script_changed)

#func send_list(script_list):
#	var list = {}
#	for each in script_list:
#		list[each] = script_list[each].source_code
##	for each in colab_tool.network.mpapi.get_peers():
##		colab_tool.network.mpapi.rpc(each, colab_tool.network.node, "get_scriptlist", [list])

func editor_script_changed(script):
	## triggered when user changes/opens script
	if not str(script.resource_path) in script_list:
		script_list[str(script.resource_path)] = {"obj": script, "last": 0}
	script_base = editor.get_current_editor()
	if script_base.is_connected("name_changed", update_script) == false:
		script_base.connect("name_changed", update_script.bind(script))

func update_script(script):
	#triggers on script change and validation attempt
	if not str(script.resource_path) in script_list:
		script_list[str(script.resource_path)] = {"obj": script, "last": 0}
	var time = Time.get_ticks_msec()
	script_list[str(script.resource_path)]["last"] = time
	if colab_tool.network.mpapi.is_server() == true:
		colab_tool.network.mpapi.rpc(0, colab_tool.network.node, "Script_updated", [str(script.resource_path), script.source_code, time])
	else:
		colab_tool.network.mpapi.rpc(1, colab_tool.network.node, "Script_updated", [str(script.resource_path), script.source_code, 0])
