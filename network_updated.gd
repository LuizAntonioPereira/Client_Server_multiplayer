extends VBoxContainer


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextEdit_text_changed(new_text):
	Network.ip_address = new_text
	print(Network.ip_address)


func _on_ServerButton_pressed():
	Network.create_server()


func _on_ClientButton_pressed():
	Network.join_server()
	get_tree().get_network_unique_id()


func _on_SendButton_pressed():
	pass # Replace with function body.
