extends StaticBody2D

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	$AudioStreamPlayer2D.set_volume_db(gamestate.sound_volume-13)
	if gamestate.mute_sounds:
		$AudioStreamPlayer2D._set_playing(false)
	elif !$AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D._set_playing(true)

func _on_DespawnTimer_timeout():
	$AnimationPlayer.play("despawn")

func _on_AnimationPlayer_animation_finished( anim_name ):
	if anim_name == "despawn":
		queue_free()