extends KinematicBody2D

var area
var big_area
var space_state
#var dir = Vector2(1,0)
var angle = randf()*2
var dir = Vector2(cos(angle),sin(angle))
var speed = 5000

var alignment_factor = 0.3
var separation_factor = 0.1
var cohesion_factor = 0.1
var repeller_factor = 0.2
var obstacle_factor = 0.2
var pedestrian_factor = 0.1
var random_factor = 0.02
var old_dir_factor = 0.3

var random_spread = 2*PI

var ray_length = 100

var repeller_radius = 400.0

var blind_angle = PI/4

var pedestrian_damage = 5
var player_damage = 5

var ray1_factor = 1.5
var ray2_factor = 0.5
var ray3_factor = 1.0

var debug_vector1 = Vector2(0,0)
var debug_vector2 = Vector2(0,0)
var debug_vector3 = Vector2(0,0)
var debug_vector4 = Vector2(0,0)

func _draw():
	pass
	#draw_line(Vector2(0,0), 100*dir, Color(1,0,0),1,true)
	#draw_line(Vector2(0,0), 100*debug_vector1, Color(0,1,0),1,true)
	#draw_line(Vector2(0,0), 100*debug_vector2, Color(0,0,1),1,true)
	#draw_line(Vector2(0,0), 100*debug_vector3, Color(1,1,0),1,true)
	#draw_line(Vector2(0,0), 100*debug_vector4, Color(0,1,1),1,true)

func _ready():
	area = get_node("Neighbourarea")
	big_area = get_node("Biggerarea")
	space_state = get_world_2d().get_direct_space_state()
	$AnimatedSprite.set_frame(randi()%$AnimatedSprite.get_sprite_frames().get_frame_count("walk_right"))
	$AnimatedSprite.play()
	
func _process(delta):
	update()
	
func _physics_process(delta):
	move_and_slide(dir*speed*delta)
	
	for i in range(get_slide_count()-1):
		var collider = get_slide_collision(i).collider
		if collider.is_in_group("pedestrian"):
			var pedestrian = collider
			
			pedestrian.get_damaged(pedestrian_damage)
		if collider.is_in_group("player"):
			var player = collider
			
			player.get_damaged(player_damage)
	
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			$AnimatedSprite.play("walk_right")
			$AnimatedSprite.set_flip_h(false)
		else:
			$AnimatedSprite.play("walk_right")
			$AnimatedSprite.set_flip_h(true)
	else:
		if dir.y > 0:
			$AnimatedSprite.play("walk_down")
		else:
			$AnimatedSprite.play("walk_up")
	
	var repellers = get_tree().get_nodes_in_group("repeller")
	
	var repeller_dir = Vector2(0,0)
	
	for repeller in repellers:
		var to_repeller = repeller.position - self.position
		
		if to_repeller.length() < repeller_radius:
			repeller_dir += to_repeller
			
	repeller_dir = -repeller_dir.normalized()
	
	var far_neighbours = big_area.get_overlapping_bodies()
	
	var pedestrian_dir = Vector2(0,0)
	
	for far_neighbour in far_neighbours:
		if far_neighbour.is_in_group("pedestrian"):
			var pedestrian = far_neighbour
			if pedestrian.life != 0:
				pedestrian_dir += pedestrian.position - self.position
			
	pedestrian_dir = pedestrian_dir.normalized()
		
	var obstacle_dir = Vector2(0,0)
	
	var ray_dir1 = (Vector2(dir.y,-dir.x) + dir).normalized()
	var ray_dir2 = dir
	var ray_dir3 = (Vector2(-dir.y,dir.x) + dir).normalized()
	
	var result1 = space_state.intersect_ray(self.global_position,self.global_position+ray_length*ray_dir1,[self],2)
	
	if not result1.empty():
		var dis = result1.position.distance_to(self.global_position)
		if dis != 0:
			obstacle_dir += ray1_factor * result1.normal / dis
		else:
			obstacle_dir += ray1_factor * result1.normal
		
		
	var result2 = space_state.intersect_ray(self.global_position,self.global_position+ray_length*ray_dir2,[self],2)
	
	if not result2.empty():
		var dis = result2.position.distance_to(self.global_position)
		if dis!= 0:
			obstacle_dir += ray2_factor * result2.normal / dis
		else:
			obstacle_dir += ray2_factor * result2.normal
		
	var result3 = space_state.intersect_ray(self.global_position,self.global_position+ray_length*ray_dir3,[self],2)
		
	if not result3.empty():
		var dis = result3.position.distance_to(self.global_position)
		
		if dis!=0:
			obstacle_dir += ray3_factor * result3.normal / dis
		else:
			obstacle_dir += ray3_factor * result3.normal
		
	obstacle_dir = obstacle_dir.normalized()
	
	var neighbours = area.get_overlapping_bodies()
	
	if not neighbours.empty():
		var dir_sum = Vector2(0,0)
		var pos_sum = Vector2(0,0)
		var sep_sum = Vector2(0,0)
		
		var num_neighbours=0
		
		for neighbour in neighbours:
			if neighbour.is_in_group("zombie") and neighbour!=self:
				var to_neighbour = (neighbour.position - self.position)
				
				if abs(to_neighbour.angle_to(dir) - PI) > blind_angle:
					dir_sum+=neighbour.dir
					pos_sum+=neighbour.position
					num_neighbours+=1
					if to_neighbour.length_squared() !=0:
						sep_sum+=to_neighbour * 1/(to_neighbour.length_squared())
					else:
						sep_sum+=to_neighbour
				
		var avg_dir = dir_sum.normalized()
		var sep_avg = -sep_sum.normalized()
		
		var avg_pos = self.position
		
		if(num_neighbours !=0):
			avg_pos = pos_sum/num_neighbours
		
		var dir_to_avg_pos = (avg_pos - self.position).normalized()
		
		var random_angle = dir.angle() + (randf()-0.5)*random_spread
		var random_dir = Vector2(cos(random_angle),sin(random_angle))
		
		dir = old_dir_factor * dir
		dir += alignment_factor * avg_dir
		dir += cohesion_factor * dir_to_avg_pos
		dir += separation_factor * sep_avg
		dir += repeller_factor * repeller_dir
		dir += obstacle_factor * obstacle_dir
		dir += pedestrian_factor * pedestrian_dir
		dir += random_factor * random_dir
		dir = dir.normalized()
		
		debug_vector1 = dir
		debug_vector2 = random_dir
