extends Control
class_name NetworkHandler

signal foun_server
signal found_removed

var Roominfo = {"name":"name", "playerCount":0}
var braoadcaster : PacketPeerUDP
var peer : ENetMultiplayerPeer


var boradcastPort = 2500
var listentPort = 2501
const IP_ADRESS : String= "192.168.1.1"
const PORT:int = 5050


func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error!= OK:
		print(error)
	else:
		multiplayer.multiplayer_peer = peer
		print(error)

func setBradCast(name):
	Roominfo.name = name
	braoadcaster = PacketPeerUDP.new()
	braoadcaster.set_broadcast_enabled(true)
	braoadcaster.set_dest_address(IP.get_local_addresses()[0],listentPort)
	
	var error = braoadcaster.bind(boradcastPort)
	if error != OK:
		print("problemas al conectar al broadcasterport")
	else:
		print ("correcto")
	$Timer.start()
	
func _on_timer_timeout():
	print("BroadCasting Game! "+ str(multiplayer.get_peers().size())+" "+str(multiplayer.is_server()))
	Roominfo.playerCount = multiplayer.get_peers().size()
	var data = JSON.stringify(Roominfo)
	var packet = data.to_ascii_buffer()
	braoadcaster.put_packet(packet)

func _exit_tree():
	$Timer.stop()
	close_broadcaster()
		


func close_broadcaster():
	if braoadcaster != null:
		braoadcaster.close()
