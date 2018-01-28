extends Node

func _ready():
	randomize()

func _on_StartButton_pressed():
	gamestate.time_elapsed = 0
	gamestate.change_scene("res://levels/Level01.tscn")
	gamestate.level = 1

func _on_ExitButton_pressed():
	get_tree().quit()