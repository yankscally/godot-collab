extends EditorPlugin
var userscript = null
var colab_tool = null

var script_list = {}

func save_and_set_script():
	userscript = get_editor_interface().get_script_editor().get_current_script()
	script_list[str(userscript.resource_path)] = userscript
	
func script_loop():
	save_and_set_script()
	if script_list == null:
		script_list = {}
	if script_list != {}:
		send_list(script_list)

func send_list(script_list):
	var list = {}
	for each in script_list:
		list[each] = script_list[each].source_code

	for each in colab_tool.network.mpapi.get_peers():
		colab_tool.network.mpapi.rpc(each, colab_tool.network.node, "get_scriptlist", [list])

