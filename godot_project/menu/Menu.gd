extends Control

func _ready():
	randomize()
	gamestate.levelname = "menu"

func _on_StartButton_pressed():
	gamestate.time_elapsed = 0
	gamestate.change_scene("res://levels/Level01.tscn")
	gamestate.levelname = "level01"

func _on_ExitButton_pressed():
	get_tree().quit()