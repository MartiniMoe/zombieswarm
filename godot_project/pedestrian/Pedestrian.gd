extends KinematicBody2D

const MOTION_SPEED = 160
const MOVEMENT_RANGE = 200
const spr_up = preload("res://pedestrian/pedestrian-up.png")
const spr_down = preload("res://pedestrian/pedestrian-down.png")
const spr_left = preload("res://pedestrian/pedestrian-left.png")
const spr_right = preload("res://pedestrian/pedestrian-right.png")
const zombie = preload("res://zombies/Zombie.tscn")

const PS1 = preload("res://sounds/pedestrian01.wav")
const PS2 = preload("res://sounds/pedestrian02.wav")
const PS3 = preload("res://sounds/pedestrian03.wav")
const PS4 = preload("res://sounds/pedestrian04.wav")
const PS5 = preload("res://sounds/pedestrian05.wav")
const PS6 = preload("res://sounds/pedestrian06.wav")
const PS7 = preload("res://sounds/pedestrian07.wav")

var pedestrian_sounds = []

var life = 100.0

var moving = false
var movement_start
var movement_relative
var last_distance

func get_damaged(var damage):
	$Particles2D.set_emitting(true)
	
	if !$AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D.set_stream(pedestrian_sounds[randi()%pedestrian_sounds.size()])
		$AudioStreamPlayer2D.get_stream().get_audio_stream().set_loop_mode(AudioStreamSample.LOOP_DISABLED)
		$AudioStreamPlayer2D.set_volume_db(gamestate.sound_volume)
		if !gamestate.mute_sounds:
			$AudioStreamPlayer2D.play()
	
	if life > 0:
		life-=damage
	else:
		gamestate.pedestrians_alive -= 1
		set_physics_process(false)
		$AnimatedSprite.stop()
		$AnimatedSprite.hide()
		$Sprite.show()
		remove_from_group("pedestrian")
		$ResurrectTimer.start()
		$CollisionShape2D.set_disabled(true)

func _ready():
	gamestate.pedestrians_alive += 1
	
	set_physics_process(true)
	
	var rp1 = AudioStreamRandomPitch.new()
	rp1.set_audio_stream(PS1)
	var rp2 = AudioStreamRandomPitch.new()
	rp2.set_audio_stream(PS2)
	var rp3 = AudioStreamRandomPitch.new()
	rp3.set_audio_stream(PS3)
	var rp4 = AudioStreamRandomPitch.new()
	rp4.set_audio_stream(PS4)
	var rp5 = AudioStreamRandomPitch.new()
	rp5.set_audio_stream(PS5)
	var rp6 = AudioStreamRandomPitch.new()
	rp6.set_audio_stream(PS6)
	var rp7 = AudioStreamRandomPitch.new()
	rp7.set_audio_stream(PS7)
	
	var rp = 1
	rp1.set_random_pitch(rp)
	rp2.set_random_pitch(rp)
	rp3.set_random_pitch(rp)
	rp4.set_random_pitch(rp)
	rp5.set_random_pitch(rp)
	rp6.set_random_pitch(rp)
	rp7.set_random_pitch(rp)
	pedestrian_sounds.append(rp1)
	pedestrian_sounds.append(rp2)
	pedestrian_sounds.append(rp3)
	pedestrian_sounds.append(rp4)
	pedestrian_sounds.append(rp5)
	pedestrian_sounds.append(rp6)
	pedestrian_sounds.append(rp7)

func _physics_process(delta):
	if not moving:
		$AnimatedSprite.stop()
		if randi()%200 == 0:
			moving = true
			movement_relative = Vector2(randi()%MOVEMENT_RANGE-MOVEMENT_RANGE/2, randi()%MOVEMENT_RANGE-MOVEMENT_RANGE/2)
			movement_start = get_global_position()
			last_distance = get_global_position().distance_to(movement_start + movement_relative)
			if abs(movement_relative.y) > abs(movement_relative.x):
				if movement_relative.y > 0:
					$AnimatedSprite.play("walk_down")
				else:
					$AnimatedSprite.play("walk_up")
			else:
				if movement_relative.x > 0:
					$AnimatedSprite.set_flip_h(false)
					$AnimatedSprite.play("walk_right")
				else:
					$AnimatedSprite.set_flip_h(true)
					$AnimatedSprite.play("walk_right")
	else:
		var distance = get_global_position().distance_to(movement_start + movement_relative)
		if distance <= last_distance:
			last_distance = distance
			move_and_slide(movement_relative.normalized() * MOTION_SPEED)
		else:
			moving = false

func _on_ResurrectTimer_timeout():
	var z = zombie.instance()
	z.set_global_position(get_global_position())
	get_parent().add_child(z)
	queue_free()