extends "res://assets/scripts/Main.gd"

func respondInput(pos, piece):
	var row = brd.screenToBoard(pos.x)
	var col = brd.screenToBoard(pos.y)
	brd.placePiece(row, col, piece)
	
	if brd.paused == false && brd.turn % 2 == 1:
		while brd.placePiece(randi() % 3, randi() % 3, brd.Piece.O) == false:
			pass

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		if event.button_index == BUTTON_LEFT: 
			if brd.turn % 2 != 1:
				respondInput(event.position, brd.Piece.X)
