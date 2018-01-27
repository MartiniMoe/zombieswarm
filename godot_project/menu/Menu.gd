extends Control

func _ready():
	randomize()

func _on_StartButton_pressed():
	get_tree().change_scene("res://level01/Level01.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()