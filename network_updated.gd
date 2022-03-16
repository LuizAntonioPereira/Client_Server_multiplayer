extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextEdit_text_changed(new_text):
	Network.ip_address = new_text


func _on_ServerButton_pressed():
	Network.create_server()


func _on_ClientButton_pressed():
	Network.join_server()


func _on_SendButton_pressed():
	pass # Replace with function body.
