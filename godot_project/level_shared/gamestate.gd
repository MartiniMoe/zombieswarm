extends Node

var time_elapsed = 0

var main
var gui
var player

var level = 0

var pedestrians_alive = 0
var zombies_alive = 0

var level_defeated = false
var level_won = false

func _ready():
	set_process(true)

func _process(delta):
	time_elapsed += delta
	
	if level != 0 && time_elapsed > 1:
		if zombies_alive <= 0:
			# check if there is a next level
			var levelcheck = File.new()
			var levelexists = levelcheck.file_exists("res://levels/Level0" + str(level+1) + ".tscn")
			
			if levelexists:
				gui.get_node("Win").show()
				level_won = true
				level_defeated = false
			else:
				level = 0
				gui.get_node("WinOverall").show()
				level_won = true
				level_defeated = false
				gui.get_node("WinOverall/P1").set_emitting(true)
				gui.get_node("WinOverall/P2").set_emitting(true)
				gui.get_node("WinOverall/P3").set_emitting(true)
				gui.get_node("WinOverall/P4").set_emitting(true)
				gui.get_node("WinOverall/P5").set_emitting(true)
				gui.get_node("WinOverall/P6").set_emitting(true)
		elif pedestrians_alive <= 0:
			gui.get_node("Defeat").show()
			level_defeated = true
			level_won = false
		elif player.life <= 0:
			gui.get_node("DefeatDeath").show()
			level_defeated = true
			level_won = false

func change_scene(scene):
	pedestrians_alive = 0
	zombies_alive = 0
	for child in main.get_node("Scene").get_children():
		child.queue_free()
	main.get_node("Scene").add_child(load(scene).instance())