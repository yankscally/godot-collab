@tool
extends EditorPlugin

var caret_pos
@onready var name_tag = preload("res://addons/godot-collab/control_panel/name_tag.tscn").instantiate()
var name_display = false
var code_edit_node

func _enter_tree():
	#print(current_script.source_code)
	var editor = get_editor_interface()
	editor.get_base_control().add_child(name_tag)
	name_tag.owner = editor
	
	var dock = preload("res://addons/godot-collab/control_panel/godot_collab_ui.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	

	var script_editor = get_editor_interface().get_script_editor()

func  _ready():
	var code_edit_node = get_editor_interface().get_script_editor().get_current_editor().get_base_editor()
	if name_display == false:
		code_edit_node.add_child(name_tag)
		
func _process(delta):
	var textedit = get_editor_interface().get_script_editor().get_current_editor().get_base_editor()
	var line = textedit.get_caret_line()
	var column = textedit.get_caret_column()
	if name_display == false:
		textedit.add_child(name_tag)
		name_display = true



	#print(current_script.get_property_list())
	var editor = get_editor_interface()
	var settings = editor.get_editor_settings()
	


	
	# Get line and character count
	
	# Compensate for code folding
	var folding_adjustment = 0
	for i in range(textedit.get_line_count()):
		if i > line:
			break


	# Compensate for tab size
	var tab_size = settings.get_setting("text_editor/behavior/indent/size")
	var line_text = textedit.get_line(line).substr(0,column)
	column += line_text.count("\t") * (tab_size - 1)

	# Compensate for scroll
	var vscroll = textedit.scroll_vertical
	var hscroll = textedit.scroll_horizontal
	

	textedit.scroll_vertical = vscroll
	
	# Compensate for line spacing
	var line_spacing = settings.get_setting("text_editor/appearance/whitespace/line_spacing")
	
	# Load editor font
	var font = FontVariation.new()
	font.set_base_font(load(settings.get_setting("interface/editor/code_font")))
	#font.font_size = settings.get_setting("interface/editor/code_font_size")
	var fontsize = font.get_string_size(" ")
	
	# Compensate for editor scaling
	var scale = editor.get_editor_scale()

	# Compute gutter width in characters
	var line_count = textedit.get_line_count()
	var gutter = str(line_count).length() + 6
	
	# Compute caret position
	var pos = Vector2()
	pos.x = (gutter + column) * fontsize.x + 567 * scale - hscroll
	pos.y = (line - folding_adjustment - vscroll) * (fontsize.y + line_spacing - 2) + 100
	pos.y *= scale
	
	if str(caret_pos) == "(-1, -1)":
		caret_pos = code_edit_node.get_pos_at_line_column(line,column-1)
	else:
		caret_pos
	
	name_tag.position = Vector2(pos)

