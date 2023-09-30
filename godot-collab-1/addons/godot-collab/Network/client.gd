@tool
extends Node
var collab_tool
var peer_id = 0
var script_path = ""
var caret_pos = []
var latency = 0

var process = true
func _process(_delta):
	if collab_tool:
		if process:
			if peer_id != collab_tool.network.id:
				peer_id = collab_tool.network.id
				collab_tool.network.user_list[str(peer_id)] = self
				print("new id set")
			else:
				process = false

func deleted_lines(from,to,caret_pos,script):
	script_path = str(script.resource_path)
	var lines = []
	while from <= to:
		lines.append([from])
		from += 1
	trigger_edit_script(0, lines, script_path)
	
func edited_line(from,to,caret_pos,script_view,script):
	script_path = str(script.resource_path)
	var lines = []
	while from <= to:
		lines.append([from, script_view.get_line(from)])
		from += 1
	trigger_edit_script(1,lines,script_path)

func trigger_edit_script(type,lines ,script_path ):
	if collab_tool.network.mpapi.is_server():
		collab_tool.network.mpapi.rpc(0, collab_tool.network.node, "transmit_edit_script", [int(type), lines, str(script_path)])
	else:
		collab_tool.network.mpapi.rpc(1, collab_tool.network.node, "transmit_edit_script", [int(type), lines, str(script_path)])

#
#func _on_timer_timeout():
#	if collab_tool:
#		print(peer_id)
#		collab_tool.network.mpapi.rpc(0, collab_tool.network.node, "heartbeat", [ Time.get_ticks_msec() ])
#
#func heartbeat(time, _id):
#	var new_time = Time.get_ticks_msec()
#	latency = float(new_time - time / 2)
#	print(_id, "  ", latency)
