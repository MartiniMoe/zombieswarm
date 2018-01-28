extends Control

var cooldown_timer
var last_progress = 100
var level = 1

func _ready():
	gamestate.gui = self
	set_physics_process(true)
	$PedestrianCount.set_position(Vector2(10, 20))
	$ZombieCount.set_position(Vector2(10, 80))

func _physics_process(delta):
	$PedestrianCount/Background/Number.set_text(str(gamestate.pedestrians_alive))
	$ZombieCount/Background/Number.set_text(str(gamestate.zombies_alive))
	
	if gamestate.player.get_node("RepellerCooldown") != null:
		cooldown_timer = gamestate.player.get_node("RepellerCooldown")
		var progress = (1 - cooldown_timer.get_time_left() / cooldown_timer.get_wait_time()) * 100
		$RepellerTimer/TextureProgress.set_value(progress)
	
		if progress == 100 and last_progress != 100:
			$RepellerTimer/AnimationPlayer.play("flash")
		
		last_progress = progress

func _on_button_next_level_pressed():
	gamestate.level_defeated = false
	gamestate.level_won = false
	gamestate.levelname = "level0" + str(level+1)
	gamestate.change_scene("res://level0" + str(level+1) + "/Level0" + str(level+1) + ".tscn")

func _on_button_restart_pressed():
	gamestate.level_defeated = false
	gamestate.level_won = false
	gamestate.levelname = "level0" + str(level)
	gamestate.change_scene("res://level0" + str(level) + "/Level0" + str(level) + ".tscn")