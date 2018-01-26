extends Control

func _ready():
	randomize()

func _on_Start_pressed():
	get_tree().change_scene("res://level01/Level01.tscn")