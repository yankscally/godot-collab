extends EditorPlugin
var userscript = null
var colab_tool = null
var editor = null
var script_list = {}
var script_base = null

func script_loop():
	if editor == null:
		script_list = {}
		editor = get_editor_interface().get_script_editor()
		editor.connect("editor_script_changed", editor_script_changed)

func send_list(script_list):
	var list = {}
	for each in script_list:
		list[each] = script_list[each].source_code
#	for each in colab_tool.network.mpapi.get_peers():
#		colab_tool.network.mpapi.rpc(each, colab_tool.network.node, "get_scriptlist", [list])

func editor_script_changed(script):
	## triggered when user changes/opens script
	script_list[str(script.resource_path)] = script
	script_base = editor.get_current_editor()
	script_base.connect("name_changed", update_script)

func update_script():
	#triggers on script change and validation attempt
	print("ok")
	pass
