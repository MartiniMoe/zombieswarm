extends Control

onready var cooldown_timer = get_parent().get_node("YSort/Player/RepellerCooldown")
var last_progress = 100

func _ready():
	set_physics_process(true)
	$PedestrianCount.set_position(Vector2(10, 20))
	$ZombieCount.set_position(Vector2(10, 80))

func _physics_process(delta):
	var count_pedestrian = 0
	var count_zombie = 0
	for node in get_parent().get_node("YSort").get_children():
		if node.is_in_group("pedestrian"):
			count_pedestrian = count_pedestrian + 1
		elif node.is_in_group("zombie"):
			count_zombie = count_zombie + 1
	
	$PedestrianCount/Background/Number.set_text(str(count_pedestrian))
	$ZombieCount/Background/Number.set_text(str(count_zombie))
	
	var progress = (1 - cooldown_timer.get_time_left() / cooldown_timer.get_wait_time()) * 100
	$RepellerTimer/TextureProgress.set_value(progress)
	
	if progress == 100 and last_progress != 100:
		$RepellerTimer/AnimationPlayer.play("flash")
	
	last_progress = progress