@tool
extends Node

var script_source 
var script_editor_connected = false

var updating = false

@rpc("any_peer", "unreliable")
func get_scriptlist(scriptlist):
	var script_editor_init = EditorPlugin.new()
	var script_editor = script_editor_init.get_editor_interface().get_script_editor().get_current_editor().get_base_editor()
	make_connections()
	
	var main = get_meta("tool")
	for each in scriptlist:
		if not "addons" in each:
			if not each in main.editor.script_list:
				main.editor.script_list[each] = load(each)
			main.editor.script_list[each].source_code = scriptlist[each]
			
			script_source = scriptlist[each]



			update_script(script_source)



func make_connections():
	var script_editor_init = EditorPlugin.new()
	var script_editor = script_editor_init.get_editor_interface().get_script_editor().get_current_editor().get_base_editor()
	
	if script_editor_connected == false:
		script_editor.connect("text_entered", update_script)
		script_editor_connected = true
		
func update_script(input):
	updating = true
	if updating == true:
		var script_editor_init = EditorPlugin.new()
		
		script_editor_init.get_editor_interface().get_script_editor().get_current_editor().get_base_editor().set("text", input)
		updating = false
