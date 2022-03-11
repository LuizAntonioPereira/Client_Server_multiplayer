extends Node2D

var net = NetworkedMultiplayerENet.new()
var port = 1901
var ip_address = "127.0.0.1"
var max_player = 10

var isClient = false
var isServer = false
var envio : float
var receber = 0 #: float = 4.0
var teste

onready var statusLabel = get_node("CanvasLayer/VBoxContainer/Status")
onready var btnServer = get_node("CanvasLayer/VBoxContainer/HBoxContainer/ServerButton")
onready var btnClient = get_node("CanvasLayer/VBoxContainer/HBoxContainer/ClientButton")
onready var logLabel = get_node("CanvasLayer/VBoxContainer/Log")
onready var Text = get_node("CanvasLayer/VBoxContainer/HBoxContainer/TextEdit").text

var endereco = IP.get_local_addresses()

func _ready():
	get_tree().connect("connected_to_server", self,"on_connected")
	get_tree().connect("server_disconnected", self,"on_disconnected")
	get_tree().disconnect("network_peer_connected", self,"on_client_connected")
	get_tree().disconnect("network_peer_disconnected", self,"on_client_disconnected")

func _on_ServerButton_pressed():
	print(endereco)
	print(typeof(endereco))
	if((!isClient) and (!isServer)):
		net.create_server(port,max_player)
		get_tree().network_peer = net
		statusLabel.text = "server is running \n"
		statusLabel.text += str("IP:", endereco[5], "\n")
		
		btnServer.text = "Stop Server"
		isServer = true		
		
		
	elif isServer:
		get_tree().network_peer = null
		net.close_connection()
		statusLabel.text = ""
		btnServer.text = "Start Server"
		isServer = false
		

func on_client_disconnected(id):
		print(id)
		logLabel.text += str(id) + " is disconnect \n"	
		
func on_client_connected(id):
		print(id)
		logLabel.text += str(id) + " is connect \n"
		
		teste = id					
		$CanvasLayer/VBoxContainer/HBoxContainer/SendButton.set_network_master(id)
		#$CanvasLayer/VBoxContainer/HBoxContainer/SendButton.name ="player" + str(id)

func _on_ClientButton_pressed():
	if((!isClient) and (!isServer)):
		net.create_client(Text,port)
		get_tree().network_peer = net
		statusLabel.text = "client is running"
		btnClient.text = "Stop Client"
		isClient = true
		
	elif isClient:
		get_tree().network_peer = null
		net.close_connection()
		statusLabel.text = ""
		btnClient.text = "Start Client"
		isClient = false
		get_tree().disconnect("connected_to_server", self,"on_connected")
		get_tree().disconnect("server_disconnected", self,"on_disconnected")

func on_connected(id):
	logLabel.text += "client_connected \n" + str(id)
	
func on_disconnected():
	logLabel.text += "server disconnected \n"
	
remotesync func assign_server(numero):
		
		#envio =+ envio + receber
	
		receber += numero
		#logLabel.text += str(receber) + "\n"	
		rpc("assign_client", receber)	
	
		
	#print(numero)
	
remotesync func assign_client(numero2):	

	#receber = numero
		
	logLabel.text += str(numero2) + "\n"
	#print(numero)	

func _on_SendButton_pressed():
	
	if get_tree().is_network_server():
		#rpc("assign_server",teste)
		var num = 1.0
		print("entrou no servidor")		
		rpc_unreliable_id(1,"assign_server", num)
		rpc_unreliable_id(2,"assign_client")
				
		#rpc_id(1, "assign_server")
		pass
	else:
		#rpc("assign_client",teste)
		var num2 = 2.0
		#print("entrou no servidor")		
		#rpc_unreliable( "assign_client", num)
		rpc_unreliable_id(1,"assign_server", num2)		
	pass # Replace with function body.
