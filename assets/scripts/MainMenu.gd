extends Control

func _on_PlayButton_pressed():
	get_tree().change_scene("res://assets/scenes/MainPVC.tscn")

func _on_CvC_pressed():
	get_tree().change_scene("res://assets/scenes/MainCPVCP.tscn")


func _on_PlayMP_pressed():
	get_tree().change_scene("res://assets/scenes/MainMP.tscn")
