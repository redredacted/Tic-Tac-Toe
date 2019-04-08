extends "res://assets/scripts/Main.gd"

func _on_ComputerTimer_timeout():
	if brd.paused == false && brd.turn % 2 == 1:
		while brd.placePiece(randi() % 3, randi() % 3, brd.Piece.O) == false:
			pass
	elif brd.paused == false:
		while brd.placePiece(randi() % 3, randi() % 3, brd.Piece.X) == false:
			pass
