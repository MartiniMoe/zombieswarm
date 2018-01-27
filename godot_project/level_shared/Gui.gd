extends Control

onready var cooldown_timer = get_parent().get_node("YSort/Player/RepellerCooldown")
var last_progress = 100
var level = 1

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
	
	if count_zombie == 0:
		$Win.show()
	elif count_pedestrian == 0:
		$Defeat.show()
		#$Defeat/AnimationPlayer.play("defeat")

func _on_button_next_level_pressed():
	get_tree().change_scene("res://level0" + str(level+1) + "/Level0" + str(level+1) + ".tscn")

func _on_button_restart_pressed():
	get_tree().change_scene("res://level0" + str(level) + "/Level0" + str(level) + ".tscn")