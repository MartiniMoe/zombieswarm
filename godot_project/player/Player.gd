extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/second
const spr_up = preload("res://player/player-up.png")
const spr_down = preload("res://player/player-down.png")
const spr_left = preload("res://player/player-left.png")
const spr_right = preload("res://player/player-right.png")
const repeller = preload("res://repeller/Repeller.tscn")

func _ready():
	set_process_input(true)

func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_just_pressed("place_repeller"):
		var rep = repeller.instance()
		rep.set_global_position(get_global_position())
		get_parent().add_child(rep)
	
	if Input.is_action_pressed("walk_up"):
		$Sprite.texture = spr_up
		motion += Vector2(0, -1)
	if Input.is_action_pressed("walk_down"):
		$Sprite.texture = spr_down
		motion += Vector2(0, 1)
	if Input.is_action_pressed("walk_left"):
		$Sprite.texture = spr_left
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("walk_right"):
		$Sprite.texture = spr_right
		motion += Vector2(1, 0)
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)