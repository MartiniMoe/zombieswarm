extends Area2D

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("zombie"):
			body.queue_free()