extends EditorPlugin
var userscript = null
var net = null
var send = null
var script_list = {}
var timer = 20

func save_and_set_script():
	userscript = get_editor_interface().get_script_editor().get_current_script()

	script_list[str(userscript.resource_path)] = userscript
	
func script_loop():
	save_and_set_script()
	if script_list == null:
		script_list = {}
	if script_list != {}:
		if timer <= 0:
			send.send_list(script_list)
			timer = 20
		else:
			timer -= 1
