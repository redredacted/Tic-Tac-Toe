extends "res://assets/scripts/Main.gd"

var turn : bool = false

func _on_HostBtn_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(27015, 1)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	$MPMenu.hide()
	peer.connect("peer_connected", self, "_on_Player_connected")
	peer.connect("peer_disconnected", self, "_on_Player_disconnected")
	turn = true

func _on_ConnectBtn_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client($MPMenu/IPEdit.text, 27015)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	$MPMenu.hide()
	peer.connect("connection_succeeded", self, "_on_connection_succeeded")
	peer.connect("connection_failed", self, "_on_connection_failed")
	peer.connect("server_disconnected", self, "_on_disconnected")
	turn = false

func respondInput(pos, piece):
	var row = brd.screenToBoard(pos.x)
	var col = brd.screenToBoard(pos.y)
	brd.placePiece(row, col, piece)
	turn = false
	rpc("update_board", row, col, piece)

remote func update_board(row, col, piece):
	brd.placePiece(row, col, piece)
	turn = true

func _input(event):
	if event is InputEventMouseButton && event.pressed && turn:
		if event.button_index == BUTTON_LEFT: 
			if brd.turn % 2 != 1:
				if get_tree().is_network_server():
					respondInput(event.position, brd.Piece.X)
			else:
				respondInput(event.position, brd.Piece.O)

remote func ready_up():
	brd.show();

#serverside events
func _on_Player_connected(id):
	print("Player, " + str(id) + " connected")
	rpc("ready_up")
	ready_up()

func _on_Player_disconnected(id):
	print("Player, " + str(id) + " disconnected")
	$MPMenu.show()
	brd.hide()
	get_tree().set_network_peer(null)

#client events
func _on_connection_succeeded():
	print("Connected")

func _on_connection_failed():
	print("Connection Failed")
	$MPMenu.show()
	brd.hide()

func _on_disconnected():
	print("Disconected")
	$MPMenu.show()
	brd.hide()
	get_tree().set_network_peer(null)

func _game_over(winner):
	$UI/GridContainer/NewGame.hide()
	._game_over(winner)
	