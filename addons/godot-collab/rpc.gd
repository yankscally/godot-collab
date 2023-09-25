@tool
extends Node

@rpc("any_peer", "unreliable")
func get_scriptlist(scriptlist, main):
	main = get_node_or_null(main)
	if main != null:
		for each in scriptlist:
			if not "addons" in each:
				if not each in main.editor.script_list:
					main.editor.script_list[each] = load(each)
				main.editor.script_list[each].source_code = scriptlist[each]
				print(scriptlist[each])
