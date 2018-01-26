extends KinematicBody2D

const MOTION_SPEED = 160
var MOVEMENT_RANGE = 200

var moving = false
var movement_start
var movement_relative

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if not moving:
		if randi()%200 == 0:
			moving = true
			movement_relative = Vector2(randi()%MOVEMENT_RANGE-MOVEMENT_RANGE/2, randi()%MOVEMENT_RANGE-MOVEMENT_RANGE/2)
			print("moving, relative is " + str(movement_relative))
			movement_start = get_global_position()
	else:
		var distance = get_global_position().distance_to(movement_start + movement_relative)
		if distance >= 2:
			move_and_slide(movement_relative.normalized() * MOTION_SPEED)
		else:
			print("stopping")
			moving = false