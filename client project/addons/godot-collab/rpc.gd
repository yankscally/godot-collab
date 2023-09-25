@tool
extends Node

var script_source 


@rpc("any_peer", "unreliable")
func get_scriptlist(scriptlist, main):
	var script_editor_init = EditorPlugin.new()
	var script_editor = script_editor_init.get_editor_interface().get_script_editor().get_current_editor().get_base_editor()
	main = get_node_or_null(main)
	if main != null:
		for each in scriptlist:
			if not "addons" in each:

				if not each in main.editor.script_list:
					main.editor.script_list[each] = load(each)
				
				main.editor.script_list[each].source_code = scriptlist[each]
				
				print(scriptlist[each])
