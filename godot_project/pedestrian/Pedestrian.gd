extends KinematicBody2D

const MOTION_SPEED = 160
const MOVEMENT_RANGE = 200
const spr_up = preload("res://pedestrian/pedestrian-up.png")
const spr_down = preload("res://pedestrian/pedestrian-down.png")
const spr_left = preload("res://pedestrian/pedestrian-left.png")
const spr_right = preload("res://pedestrian/pedestrian-right.png")

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
			movement_start = get_global_position()
			if abs(movement_relative.y) > abs(movement_relative.x):
				if movement_relative.y > 0:
					$Sprite.texture = spr_down
				else:
					$Sprite.texture = spr_up
			else:
				if movement_relative.x > 0:
					$Sprite.texture = spr_right
				else:
					$Sprite.texture = spr_left
	else:
		var distance = get_global_position().distance_to(movement_start + movement_relative)
		if distance >= 2:
			move_and_slide(movement_relative.normalized() * MOTION_SPEED)
		else:
			moving = false