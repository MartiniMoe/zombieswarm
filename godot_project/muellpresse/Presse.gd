extends StaticBody2D

var zombies = []

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("zombie"):
			body.get_node("CollisionShape2D").set_disabled(true)
			body.set_physics_process(false)
			zombies.append(body)

func stomp():
	$AnimatedSprite.play("close")
	$CollisionDoor.set_disabled(false)
	

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "close":
		$AnimatedSprite.play("stomp")
		if zombies.size() > 0:
			$Particles2D.set_emitting(true)
		for zombie in zombies:
			zombie.queue_free()
		zombies = []
	elif $AnimatedSprite.get_animation() == "stomp":
		$AnimatedSprite.play("open")
	elif $AnimatedSprite.get_animation() == "open":
		$CollisionDoor.set_disabled(true)