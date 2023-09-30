@tool
extends VBoxContainer

var user = ""
var ip = ""
var port = ""
var colab_tool = null
var server = false
var started = false
var colour = ""

func _ready():
	$HostSync.visible = false

func _on_ip_address_text_changed():
	ip = $ip_address.text

func _on_server_toggled(button_pressed):
	if button_pressed == true:
		$ip_label.visible = false
		$ip_address.visible = false
	else:
		$ip_label.visible = true
		$ip_address.visible = true
	server = button_pressed

func _on_start_pressed():
	if started == true:
		started = false
		for child in get_children():
			child.visible = true
		$start.text = "Start"
	else:
		started = true
		for child in get_children():
			child.visible = false
		$start.text = "Stop"
	$start.visible = true
	$HostSync.visible = true
	colab_tool.dock_start(server,ip,port,user,colour,started)


func _on_port_text_changed():
	var text = $port.text
	if str(text).is_valid_int():
		port = int(text)
	else:
		$port.text = port


func _on_useri_text_changed():
	user = $useri.text


func _on_host_sync_pressed():
	colab_tool.editor.host_sync_files()
