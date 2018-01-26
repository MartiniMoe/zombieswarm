extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/second

func _ready():
	set_process_input(true)

func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("walk_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("walk_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("walk_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("walk_right"):
		motion += Vector2(1, 0)
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)