extends StaticBody2D

func _on_DespawnTimer_timeout():
	$AnimationPlayer.play("despawn")

func _on_AnimationPlayer_animation_finished( anim_name ):
	if anim_name == "despawn":
		queue_free()