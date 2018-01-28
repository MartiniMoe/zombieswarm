extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/second
const spr_up = preload("res://player/player-up.png")
const spr_down = preload("res://player/player-down.png")
const spr_left = preload("res://player/player-left.png")
const spr_right = preload("res://player/player-right.png")
const repeller = preload("res://repeller/Repeller.tscn")

var life = 100

func get_damaged(var damage):
	$Particles2D.set_emitting(true)
	if life > 0:
		life-=damage
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_rotation_degrees(90)

func _ready():
	gamestate.player = self
	set_process_input(true)

func _physics_process(delta):
	if !gamestate.level_defeated:
		var motion = Vector2()
		
		if Input.is_action_just_released("pause"):
			print("pausing")
			gamestate.pause_game()
		
		if Input.is_action_just_pressed("place_repeller"):
			if self in get_parent().get_node("Switch").get_overlapping_bodies():
				# activate press
				get_parent().get_node("Presse").stomp()
			elif $RepellerCooldown.time_left == 0:
				var rep = repeller.instance()
				rep.set_global_position(get_global_position())
				get_parent().add_child(rep)
				$RepellerCooldown.start()
		
		var animation = "walk_right"
		if Input.is_action_pressed("walk_up"):
			animation = "walk_up"
			motion += Vector2(0, -1)
		if Input.is_action_pressed("walk_down"):
			animation = "walk_down"
			motion += Vector2(0, 1)
		if Input.is_action_pressed("walk_left"):
			animation = "walk_right"
			$AnimatedSprite.set_flip_h(true)
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("walk_right"):
			animation = "walk_right"
			$AnimatedSprite.set_flip_h(false)
			motion += Vector2(1, 0)
		
		$AnimatedSprite.set_animation(animation)
		motion = motion.normalized() * MOTION_SPEED
		
		if motion != Vector2(0, 0):
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()
		
		move_and_slide(motion)