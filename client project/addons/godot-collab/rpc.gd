@tool
extends Node
var script_editor

var script_source 


func _ready():
	var editor = EditorPlugin.new()
	script_editor = editor.get_editor_interface().get_script_editor().get_current_editor().get_base_editor()
	script_editor.connect("text_changed", update_script)

@rpc("any_peer", "unreliable")
func get_scriptlist(scriptlist):
	## tool is meta on this node, it shouold ref collab_tool
	var main = get_meta("tool")
	for each in scriptlist:
		if not "addons" in each:
			if not each in main.editor.script_list:
				main.editor.script_list[each] = load(each)
			main.editor.script_list[each].source_code = scriptlist[each]
			
			script_source = scriptlist[each]
			update_script(script_source)

func update_script(input):
		script_editor.set("text", input)
