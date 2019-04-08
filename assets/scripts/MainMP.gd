extends "res://assets/scripts/Main.gd"

var turn : bool = false
var peer : NetworkedMultiplayerENet
var client : int

func _on_HostBtn_pressed():
	peer = NetworkedMultiplayerENet.new()
#warning-ignore:return_value_discarded
	peer.create_server(27015, 1)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	$MPMenu.hide()
#warning-ignore:return_value_discarded
	peer.connect("peer_connected", self, "_on_Player_connected")
#warning-ignore:return_value_discarded
	peer.connect("peer_disconnected", self, "_on_Player_disconnected")
	turn = true

func _on_ConnectBtn_pressed():
	peer = NetworkedMultiplayerENet.new()
#warning-ignore:return_value_discarded
	peer.create_client($MPMenu/IPEdit.text, 27015)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	$MPMenu.hide()
#warning-ignore:return_value_discarded
	peer.connect("connection_succeeded", self, "_on_connection_succeeded")
#warning-ignore:return_value_discarded
	peer.connect("connection_failed", self, "_on_connection_failed")
#warning-ignore:return_value_discarded
	peer.connect("server_disconnected", self, "_on_disconnected")
	turn = false

func respondInput(pos, piece):
	var row = brd.screenToBoard(pos.x)
	var col = brd.screenToBoard(pos.y)
	rpc("update_board", row, col, piece)

remotesync func update_board(row, col, piece):
	brd.placePiece(row, col, piece)
	turn = !turn

func _input(event):
	if event is InputEventMouseButton && event.pressed && turn:
		if event.button_index == BUTTON_LEFT: 
			if brd.turn % 2 != 1:
				if get_tree().is_network_server():
					respondInput(event.position, brd.Piece.X)
			else:
				respondInput(event.position, brd.Piece.O)

remotesync func ready_up():
	brd.show();

#serverside events
func _on_Player_connected(id):
	print("Player, " + str(id) + " connected")
	client = id
	rpc("ready_up")

func _on_Player_disconnected(id):
	_on_MainMenu_pressed()
	print("Player, " + str(id) + " disconnected")

#client events
func _on_connection_succeeded():
	print("Connected")

func _on_connection_failed():
	_on_MainMenu_pressed()
	print("Connection Failed")

func _on_disconnected():
	_on_MainMenu_pressed()
	print("Disconected")

func _game_over(winner):
	#$UI/GridContainer/NewGame.hide()
	._game_over(winner)

remotesync func restart():
	if get_tree().is_network_server():
		turn = true
	else:
		turn = false
	
	._restartGame()

func _on_NewGame_pressed():
	rpc("restart")

func _on_MainMenu_pressed():
	peer.close_connection(10)
	._on_MainMenu_pressed()