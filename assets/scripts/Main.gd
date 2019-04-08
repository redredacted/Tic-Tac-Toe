extends Node

export (PackedScene) var Board
onready var brd = $Board 
onready var UI  = $UI

func _ready():
#warning-ignore:return_value_discarded
	$Board.connect("gameover", self, "_game_over")

func _game_over(winner):
	$UI/WinLabel.text = winner
	$UITimer.start()

func _restartGame():
	brd.erase()
	brd = Board.instance()
	brd.connect("gameover", self, "_game_over")
	add_child(brd)
	UI.hide()


func _on_MainMenu_pressed():
#warning-ignore:return_value_discarded
	get_tree().change_scene("res://assets/scenes/MainMenu.tscn")


func _on_UITimer_timeout():
	UI.show()
	$UITimer.stop()
