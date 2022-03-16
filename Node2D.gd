extends Node2D


var port = 1901
var ip_address #= "127.0.0.1"
var max_player = 10

var client = null
var server = null

var envio : float
var receber = 0 #: float = 4.0
var teste

#onready var statusLabel = get_node("CanvasLayer/VBoxContainer/Status")
#onready var logLabel = get_node("CanvasLayer/VBoxContainer/Log")

#var endereco = IP.get_local_addresses()

func _ready():
	get_tree().connect("network_peer_connected", self, "on_client_connected")
	get_tree().connect("network_peer_disconnected", self, "on_client_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected")
	get_tree().connect("server_disconnected", self, "on_disconnected")
	get_tree().connect("connection_failed",self,"_connection_failed")
	
func create_server():

	server = NetworkedMultiplayerENet.new()
	server.create_server(port,max_player)
	get_tree().set_network_peer(server)
	print("server is running \n")
	print(str("IP:", get_ip_address(), "\n"))
	
func on_client_disconnected(id):
	#	print(id)
		print(str(id) + " is disconnect \n")
		
func on_client_connected(id):
	#	print(id)
		print(str(id) + " is connect \n")
		
	#	teste = id					
	#	$CanvasLayer/VBoxContainer/HBoxContainer/SendButton.set_network_master(id)
		#$CanvasLayer/VBoxContainer/HBoxContainer/SendButton.name ="player" + str(id)

func _connection_failed():
	print("falha de conexao com servidor")
#	reset_network_connection()

#func reset_network_connection():
#	if get_tree().has.network_peer():
#		get_tree().network_peer = null


func join_server():
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address,port)
	get_tree().set_network_peer(client)
	print("client is running")
	
func on_connected(id):
	print("client_connected \n" + str(id))
	
func on_disconnected():
	print("server disconnected \n")
	
remotesync func assign_server(numero):
		
		#envio =+ envio + receber
	
		receber += numero
		#logLabel.text += str(receber) + "\n"	
		rpc("assign_client", receber)	
	
		
	#print(numero)
	
remotesync func assign_client(numero2):	

	#receber = numero
		
	print(str(numero2) + "\n")
	#print(numero)	

func _on_SendButton_pressed():
	
	var id = get_tree().get_network_unique_id()
	
	if get_tree().is_network_server():
		#rpc("assign_server",teste)
		var num = 1.0
		print("entrou no servidor")		
		rpc_unreliable_id(id,"assign_server", num)
		rpc_unreliable_id(id,"assign_client")
				
		#rpc_id(1, "assign_server")
		pass
	else:
		#rpc("assign_client",teste)
		var num2 = 2.0
		#print("entrou no servidor")		
		#rpc_unreliable( "assign_client", num)
		rpc_unreliable_id(id,"assign_server", num2)		
	pass # Replace with function body.
	
func get_ip_address():
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			return ip
