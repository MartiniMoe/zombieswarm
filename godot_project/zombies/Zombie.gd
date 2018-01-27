extends KinematicBody2D

var area
#var dir = Vector2(1,0)
var angle = randf()*2
var dir = Vector2(cos(angle),sin(angle))
var speed = 5000

var alignment_factor = 0.3
var separation_factor = 0.2
var cohesion_factor = 0.18

var num_neighbours = 0

var blind_angle = PI/4

func _ready():
	area = get_node("Neighbourarea")
	$AnimatedSprite.set_frame(randi()%$AnimatedSprite.get_sprite_frames().get_frame_count("walk_right"))
	$AnimatedSprite.play()

	
func _physics_process(delta):
	move_and_slide(dir*speed*delta)
	
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			$AnimatedSprite.play("walk_right")
			$AnimatedSprite.set_flip_h(false)
		else:
			$AnimatedSprite.play("walk_right")
			$AnimatedSprite.set_flip_h(true)
	else:
		if dir.y > 0:
			# egtl down
			$AnimatedSprite.play("walk_up")
		else:
			$AnimatedSprite.play("walk_up")
	
	var neighbours = area.get_overlapping_bodies()
	
	if not neighbours.empty():
		var dir_sum = Vector2(0,0)
		var pos_sum = Vector2(0,0)
		var sep_sum = Vector2(0,0)
		
		num_neighbours=0
		
		for neighbour in neighbours:
			if neighbour.is_in_group("zombie") and neighbour!=self:
				var to_neighbour = (neighbour.position - self.position)
				
				if abs(to_neighbour.angle_to(dir) - PI) > blind_angle:
					dir_sum+=neighbour.dir
					pos_sum+=neighbour.position
					num_neighbours+=1
					sep_sum+=to_neighbour * 1/(to_neighbour.length_squared())
				
		var avg_dir = dir_sum.normalized()
		var sep_avg = -sep_sum.normalized()
		
		var avg_pos = Vector2(0,0)
		
		if(num_neighbours !=0):
			avg_pos = pos_sum/num_neighbours
		
		var dir_to_avg_pos = (avg_pos - self.position).normalized()
		
		dir = (1 - alignment_factor - cohesion_factor - separation_factor) * dir
		dir += alignment_factor * avg_dir
		dir += cohesion_factor * dir_to_avg_pos
		dir += separation_factor * sep_avg
		dir = dir.normalized()
