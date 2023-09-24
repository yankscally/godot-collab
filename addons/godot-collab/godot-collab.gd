@tool
extends EditorScript


func _run():
	var new_script = GDScript.new()
	new_script.source_code = "hello"
	var editor = get_editor_interface()
	editor.edit_script(new_script, 0, 0, true)

