extends CharacterBody2D
var target_pos = null
var speed = 0.6
var can_hear = false
var player
var cur_speed = 0.0
var old_flip = false
var is_attacking = false
var attack_timer = 0.0
var attack_position = Vector2.ZERO
var start_position
var i = 0.1
var flip = false  
var retreating = false
var direction = Vector2(-1.0,1.0)
var can_detect = false
var normal = true
var can_chase = true
#defaults
var moving_timer = 0
var switcher = false
@onready var shell_cool: Timer = $Timer2
@onready var timer: Timer = $Timer
@onready var raycast: RayCast2D = $RayCast2D
@onready var detect: Area2D = $detect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	player = get_tree().get_first_node_in_group("player")
	timer.wait_time = randf_range(0.3,0.5)
	Manager.connect("change_pos",_change_target_pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	normal = false
	##SHELL
	if target_pos:
		print("in loops")
		global_position = lerp(global_position,target_pos,1 - exp(-speed *delta) )		
		can_chase = false
		if global_position.distance_to(target_pos)< 10.0:
			global_position = target_pos  
			shell_cool.start()  
			target_pos = null
	##CHASE
	if can_chase:
		var chases = detect.get_overlapping_bodies()
		can_detect = false
		for chase in chases:
			var groups  = chase.get_groups()
			if groups.size()>0 and groups[0] == "player":
				can_detect = true
		if raycast.can_see and player and can_detect:    
			direction = (player.global_position - global_position).normalized()
			var distance = global_position.distance_to(player.global_position)
			speed = clamp(3.0/distance *400,0.3,2.5)
			cur_speed = lerp(cur_speed,speed,delta*2)   
			##ATTACK LOGIC
			if distance <= 600.0 and not is_attacking and not retreating:
				start_position = global_position
				attack_timer = 0.0
				is_attacking = true
				attack_position =player.global_position +Vector2(sign(scale.x) *15, 0)
				i = 0.1      
			elif not is_attacking and not retreating: 
				print("can see normal")
				global_position = lerp(global_position, player.global_position, delta*0.3)                   
			if is_attacking:  
				print("attack")
				attack_timer += delta
				i += (1.0 - i)*delta*0.07
				global_position = lerp(global_position, attack_position, i)
				if global_position.distance_to(attack_position)<=20 or attack_timer >= 7.00:
					#attack_animation_play = true
					global_position = start_position
					is_attacking = false	
					direction = (player.global_position - global_position).normalized()
					retreating = true
			elif retreating: 
				print("retreat")
				direction = (player.global_position - global_position).normalized()
				global_position = lerp(global_position,start_position,1 - exp(-6 *delta))
				if global_position.distance_to(start_position) <15:
					global_position = start_position
					retreating = false
		else:
			print("normal")
			normal = true
			moving_timer += 1
			global_position.x = lerp(global_position.x,global_position.x+direction.x*90, 1 - exp(-cur_speed *delta))
			switcher = false
			if moving_timer > 100:
				switcher = true
				direction.x = -direction.x
				moving_timer = 0 
			#print("normal")
		##FLIPPING CALCS
		var flipper = player.global_position - global_position # negative means on the left, positive means on the right
		if switcher ==  true:
			old_flip = !flip
		elif normal:
			return
		else:
			old_flip = flipper.x > 5.0            	
		if flip != old_flip: 
			self.scale.x *= -1
		flip = old_flip
func _change_target_pos(new_pos):
	timer.start()
	target_pos = new_pos 

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.3,0.5)
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("shell"):
		#can_hear = true
#func _on_area_2d_area_exited(area: Area2D) -> void:
	#if area.is_in_group("shell"):
		#can_hear = false

func _on_timer_2_timeout() -> void:
	can_chase = true
