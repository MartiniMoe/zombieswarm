extends Control

var cooldown_timer
var last_progress = 100

func _ready():
	gamestate.gui = self
	set_physics_process(true)
	set_process_input(true)
	$PlayerHealth.set_position(Vector2(280, 20))
	$PedestrianCount.set_position(Vector2(10, 20))
	$ZombieCount.set_position(Vector2(10, 80))
	$PauseMenu/MusicSlider.set_value(gamestate.main.get_node("AudioStreamPlayer").get_volume_db())

func _physics_process(delta):
	$PedestrianCount/Background/Number.set_text(str(gamestate.pedestrians_alive))
	$ZombieCount/Background/Number.set_text(str(gamestate.zombies_alive))
	$PlayerHealth/Background/TextureProgress.set_value(gamestate.player.life)
	
	if $PauseMenu.is_visible():
		if Input.is_action_just_released("pause"):
			print("esc pressed")
			_on_button_resume_pressed()
	
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
	gamestate.level += 1
	gamestate.change_scene("res://levels/Level0" + str(gamestate.level) + ".tscn")

func _on_button_restart_pressed():
	gamestate.resume_game()
	gamestate.time_elapsed = 0
	gamestate.level_defeated = false
	gamestate.level_won = false
	gamestate.change_scene("res://levels/Level0" + str(gamestate.level) + ".tscn")

func _on_button_back_pressed():
	gamestate.level_defeated = false
	gamestate.level_won = false
	gamestate.level = 0
	gamestate.change_scene("res://menu/Menu.tscn")

func _on_button_resume_pressed():
	gamestate.resume_game()

func _on_button_menu_pressed():
	gamestate.resume_game()
	_on_button_back_pressed()

func _on_MusicToggle_toggled( button_pressed ):
	if button_pressed:
		gamestate.mute_music(true)
	else:
		gamestate.mute_music(false)

func _on_SoundToggle_toggled( button_pressed ):
	gamestate.mute_sounds = button_pressed

func _on_MusicSlider_value_changed( value ):
	gamestate.set_music_volume(value)

func _on_SoundSlider_value_changed( value ):
	gamestate.set_sound_volume(value)