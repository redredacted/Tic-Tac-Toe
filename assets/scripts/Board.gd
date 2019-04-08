extends Node2D

export (PackedScene) var x : PackedScene
export (PackedScene) var o : PackedScene

var Board : Array  = []
var paused : bool = false
var turn : int = 0

enum Piece {
	X,
	O
}

signal gameover

func genBoard() -> void:
	for i in range(3):
		var temp = []
		for j in range(3):
			temp.append(null)
		Board.append(temp)

func _ready():
	genBoard()

func screenToBoard(input) -> int:
	var out
	
	if input < 200:
		out = 0
	elif input > 200 && input < 400:
		out = 1
	elif input > 400:
		out = 2
	
	return out

#returns true when gameover
func determineWinner() -> bool:
	var row1  = Board[0]
	var row2  = Board[1]
	var row3  = Board[2]
	var col1  = [Board[0][0], Board[1][0], Board[2][0]]
	var col2  = [Board[0][1], Board[1][1], Board[2][1]]
	var col3  = [Board[0][2], Board[1][2], Board[2][2]]
	var diag1 = [Board[0][0], Board[1][1], Board[2][2]]
	var diag2 = [Board[0][2], Board[1][1], Board[2][0]]
	
	if row1.count(Piece.X) == 3 or row2.count(Piece.X) == 3 or row3.count(Piece.X) == 3 or col1.count(Piece.X) == 3 or col2.count(Piece.X) == 3 or col3.count(Piece.X) == 3 or diag1.count(Piece.X) == 3 or diag2.count(Piece.X) == 3:
		emit_signal("gameover", "X Won!")
		return true
	elif row1.count(Piece.O) == 3 or row2.count(Piece.O) == 3 or row3.count(Piece.O) == 3 or col1.count(Piece.O) == 3 or col2.count(Piece.O) == 3 or col3.count(Piece.O) == 3 or diag1.count(Piece.O) == 3 or diag2.count(Piece.O) == 3:
		emit_signal("gameover", "O Won!")
		return true
	elif row1.count(null) == 0 and row2.count(null) == 0 and row3.count(null) == 0 and col1.count(null) == 0 and col2.count(null) == 0 and col3.count(null) == 0 and diag1.count(null) == 0 and diag2.count(null) == 0:
		print("tie")
		emit_signal("gameover", "Tie Game!")
		return true
	return false

#returns true if placing piece was sucessful
func placePiece(row, col, piece) -> bool:
	if Board[row][col] == null && paused == false:
		Board[row][col] = piece
		var instance
		
		if piece == Piece.X: 
			instance = x.instance() 
		else: 
			instance = o.instance()
		
		instance.transform.origin.x = 100 + (row * 200)
		instance.transform.origin.y = 100 + (col * 200)
		add_child(instance)
		turn += 1
		paused = determineWinner()
		return true
	else:
		return false

func erase():
	queue_free()