extends KinematicBody2D

const MOTION_SPEED = 160
const MOVEMENT_RANGE = 200
const spr_up = preload("res://pedestrian/pedestrian-up.png")
const spr_down = preload("res://pedestrian/pedestrian-down.png")
const spr_left = preload("res://pedestrian/pedestrian-left.png")
const spr_right = preload("res://pedestrian/pedestrian-right.png")
const zombie = preload("res://zombies/Zombie.tscn")

var life = 100.0

var moving = false
var movement_start
var movement_relative
var last_distance

func get_damaged(var damage):
	$Particles2D.set_emitting(true)
	if life > 0:
		life-=damage
	else:
		set_physics_process(false)
		$Sprite.set_rotation_degrees(90)
		remove_from_group("pedestrian")
		$ResurrectTimer.start()
		$CollisionShape2D.set_disabled(true)
	print(life)

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if not moving:
		if randi()%200 == 0:
			moving = true
			movement_relative = Vector2(randi()%MOVEMENT_RANGE-MOVEMENT_RANGE/2, randi()%MOVEMENT_RANGE-MOVEMENT_RANGE/2)
			movement_start = get_global_position()
			last_distance = get_global_position().distance_to(movement_start + movement_relative)
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