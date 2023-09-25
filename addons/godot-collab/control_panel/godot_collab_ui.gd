@tool
extends VBoxContainer


@export var ip_address = ""
@export var server_toggle = false
@export var port = 7878

func _on_ip_address_text_changed():
	ip_address = %ip_address.text
	print(ip_address)

func _on_port_text_changed():
	var text = $port.text
	if str(text).is_valid_int():
		port = int(text)
	else:
		$port.text = port

func _on_server_toggled(button_pressed):
	server_toggle = button_pressed


func _on_start_pressed():
	pass
