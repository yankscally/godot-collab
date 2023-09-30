@tool
extends EditorPlugin

var colab_tool = null
var editor = null
var current_script
var script_list = {}
var script_base = null
var script_view = null
var caret_pos = [0,0]
var last_call_was_signal = false

func _loop():
	if editor == null or script_base == null or script_view == null:
		editor = get_editor_interface().get_script_editor()
		editor.connect("editor_script_changed", editor_script_changed)
		script_base = editor.get_current_editor()
		script_view = script_base.get_base_editor()


func rpc_calls_change(type, lines, path):
	var top_line = null
	var edit = TextEdit.new()
	## TODO if its the same , ndependant scripts atm it edits current view
	edit.set_text(script_view.text)
	if type == 0:
		for line in lines:
			if top_line == null or line[0] < top_line:
				top_line = line[0]
			edit.remove_text( line[0], 0, line[0], 0)
	elif type == 1:
		for line in lines:
			if top_line == null or line[0] > top_line:
				top_line = line[0]
#			if line[0] >= script_view.get_line_count():
#				var newline = script_view.get_line_count()-1
#				while newline <= line[0]:
#					script_view.insert_line_at(newline, "")
#					newline += 1
			edit.set_line(line[0], line[1])
	var caret = caret_pos
	script_view.set_text(edit.text)
	script_view.set_caret_line(caret[0])
	script_view.set_caret_column(caret[1])

#### order of signal emmiting
func lines_edited(from,to,script):  ## TODO broken if statements need fixing to block blank lines when added
	if colab_tool.started:
		if script_view.get_line_count() - 1 == 0 and to == 0 and from == 0:
			script_view.insert_line_at ( 0, "" )
			print("added line   ", script_view.get_line_count(), "  ", to, "  ", from, " line")
		elif from == 0 and 1 == script_view.get_line_count() - 1 and to == 0 and script_view.get_line(from) == "":
			print("First line only")
			return
		elif from <= 1 and to == script_view.get_line_count() -1 and to > 1:
			print("blocked full text set")
			return
		print("sent ", script_view.get_line_count(), "  ", to, "  ", from, " line")
		var client_node = colab_tool.network.user_list[str(colab_tool.network.id)]
		if client_node:
			if to != from and to < from:
				client_node.deleted_lines(from,to,caret_pos,script)
			else:
				client_node.edited_line(from,to,caret_pos,script_view,script)

func caret_updated():
	caret_pos = [script_view.get_caret_line(), script_view.get_caret_column()]
###########################
func editor_script_changed(script):
	## triggered when user changes/opens script
	if not str(script.resource_path) in script_list:
		script_list[str(script.resource_path)] = {"cur": script, "edited": 0}
	current_script = script
	script_base = editor.get_current_editor()
	script_view = script_base.get_base_editor()
	if script_view.is_connected("caret_changed", caret_updated) == false:
		script_view.connect("caret_changed", caret_updated)
	if script_view.is_connected("lines_edited_from", lines_edited) == false:
		script_view.connect("lines_edited_from", lines_edited.bind(script))


	#if script_base.is_connected("name_changed", update_script) == false:
	#	script_base.connect("name_changed", update_script.bind(script))
#
#func update_script(script):
#	#triggers on script change and validation attempt
#	if not str(script.resource_path) in script_list:
#		script_list[str(script.resource_path)] = {"obj": script, "last": 0}
#	var time = Time.get_ticks_msec()
#	script_list[str(script.resource_path)]["last"] = time
#	if colab_tool.network.mpapi.is_server() == true:
#		colab_tool.network.mpapi.rpc(0, colab_tool.network.node, "Script_updated", [str(script.resource_path), script.source_code, time])
#	else:
#		colab_tool.network.mpapi.rpc(1, colab_tool.network.node, "Script_updated", [str(script.resource_path), script.source_code, 0])


	
	#.get_current_editor().get_base_editor().set_text(code)
## TODO this function is for sending all source code to clients 
func host_sync_files():
	print("who do you think you are?!!, im sitting here minding my own business and you come along and click on me")
