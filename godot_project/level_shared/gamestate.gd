extends Node

var time_elapsed = 0

var main
var gui
var player

var levelname = ""

var pedestrians_alive = 0
var zombies_alive = 0

var level_defeated = false
var level_won = false

func _ready():
	set_process(true)

func _process(delta):
	time_elapsed += delta
	
	if levelname != "menu" && time_elapsed > 1:
		if zombies_alive <= 0:
			gui.get_node("Win").show()
			level_won = true
			level_defeated = false
		elif pedestrians_alive <= 0:
			gui.get_node("Defeat").show()
			level_defeated = true
			level_won = false
		elif player.life <= 0:
			gui.get_node("DefeatDeath").show()
			level_defeated = true
			level_won = false

func change_scene(scene):
	for child in main.get_node("Scene").get_children():
		child.queue_free()
	main.get_node("Scene").add_child(load(scene).instance())