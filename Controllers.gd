extends Node
	
func setup_network(server : bool = false, ip: String = "localhost", attempt : int = 0):
	var multi = MultiplayerAPI.new()
	var network = NetworkedMultiplayerENet.new()
	if ip.is_valid_ip_address():
		if server:
			network.create_server(ip, 1234)
		else:
			network.create_client(ip, 1234)
		multi.network_peer = network
		set_custom_multiplayer(multi)
		_connect_signals(server)
	elif attempt == 0: 
		ip = IP.resolve_hostname(ip, 1)
		setup_network(server, ip, 1)
	else:
		print("Failed to resolve url/ip, verify your code")
func _verify_container_node():
	var root = get_tree().get_root()
	if root.get_node_or_null("player_controller") == null:
		var player_controller = Node.new()
		player_controller.name = "player_controller"
		# Sets the node name, this is represented in the tree only.
		root.add_child(player_controller)
		
func _connect_signals(server : bool = false):
	var from = get_custom_multiplayer()
	#List all signals for the network 
	var signals = [
		"network_peer_connected",
		"network_peer_disconnected",
		"network_peer_packet"
		]
	#List client specific signals and append them if necessary 
	if not server:
		signals.append("connected_to_server")
		signals.append("connection_failed")
		signals.append("server_disconnected")
		
	for _signal in signals: #Connect all signals at once
		from.connect(_signal,self,"_on_MultiplayerAPI_"+_signal)

func _on_MultiplayerAPI_connected_to_server():
# Emitted when this MultiplayerAPI’s network_peer successfully connected to a server. 
# Only emitted on clients.
	
	var input_interceptor = load("res://interceptor/scene.tscn").instance()
	_verify_container_node()
	input_interceptor.name = get_custom_multiplayer().get_network_unique_id()
	get_tree().get_root().get_node("player_controller").add_child(input_interceptor)

	pass
func _on_MultiplayerAPI_connection_failed():
# Emitted when this MultiplayerAPI’s network_peer fails to establish a connection to a server. 
# Only emitted on clients.
	pass
func _on_MultiplayerAPI_network_peer_connected (id : int):
#Emitted when this MultiplayerAPI’s network_peer connects with a new peer. ID is the peer ID of the new peer. Clients get notified when other clients connect to the same server. Upon connecting to a server, a client also receives this signal for the server (with ID being 1).
	pass
func _on_MultiplayerAPI_network_peer_disconnected(id : int):
#Emitted when this MultiplayerAPI’s network_peer disconnects from a peer. Clients get notified when other clients disconnect from the same server.
	pass
func _on_MultiplayerAPI_network_peer_packet (id : int , packet : PoolByteArray):
#Emitted when this MultiplayerAPI’s network_peer receive a packet with custom data (see send_bytes). ID is the peer ID of the peer that sent the packet.
	pass
func _on_MultiplayerAPI_server_disconnected():
#Emitted when this MultiplayerAPI’s network_peer disconnects from server. Only emitted on clients.
	pass
