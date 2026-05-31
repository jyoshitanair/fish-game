extends CharacterBody2D
var time1
var after_shell_move = false
var time
var target_pos = null
var speed = 0.6
var player
var cur_speed = 0.0
var norm_speed = 200.0
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
var in_loop_timer = 0 
var can_move = true
var hit_dat_wall = false
var new_target_pos
var shell_mode = false
#defaults
var moving_timer = 0
var switcher = false
@onready var shell_cool: Timer = $Timer2
@onready var timer: Timer = $Timer
@onready var raycast: RayCast2D = $RayCast2D
@onready var detect: Area2D = $detect
@onready var shell_timer: Timer = $shell_timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	add_to_group("shark")
	start_position = global_position
	player = get_tree().get_first_node_in_group("player")
	timer.wait_time = randf_range(0.3,0.5)
	Manager.connect("change_pos",_change_target_pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	##SHELL
	if shell_mode: 
		var lerper = lerp(global_position,new_target_pos,1 - exp(-speed *delta))
		velocity = (lerper - global_position)/delta
		move_and_slide()
	if after_shell_move: 
		velocity = velocity.lerp(direction*400, 1.0 - exp(-speed*delta))
		move_and_slide()
		time -= delta
		if time <= 0:
			after_shell_move = false
			can_move = true
	if can_move:
		if target_pos:
			in_loop_timer += 1 
			var lerper = lerp(global_position,target_pos,1 - exp(-speed *delta))
			velocity = (lerper - global_position)/delta
			move_and_slide()
			can_chase = false
			if global_position.distance_to(target_pos)< 10.0 or in_loop_timer == 300:
				global_position = target_pos  
				shell_cool.start()  
				target_pos = null
				in_loop_timer = 0 
		##CHASE
		if can_chase:
			if raycast.can_see and player and can_detect:   
				direction = (player.global_position - global_position).normalized()
				var distance = global_position.distance_to(player.global_position)
				speed = clamp(3.0/distance *400,0.3,10.5)
				cur_speed = lerp(cur_speed,speed,delta*2)   
				##ATTACK LOGIC
				if distance <= 600.0 and not is_attacking and not retreating:
					start_position = global_position
					attack_timer = 0.0
					is_attacking = true
					attack_position =player.global_position +Vector2(sign(scale.x) *15, 0)
					i = 0.1      
				elif not is_attacking and not retreating: 
					var lerper2 = lerp(global_position, player.global_position, delta*0.8)    
					velocity = (lerper2 - global_position)/delta
					move_and_slide()                  
				if is_attacking: 
					attack_timer += delta
					i += (1.0 - i)*delta*0.07
					global_position = lerp(global_position, attack_position, i)
					if global_position.distance_to(attack_position)<=20 or attack_timer >= 7.00:
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
				#first this dumb ahh needs to check if it's touching a wall. 
				if hit_dat_wall: 
					print("hit")
					direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
				normal = true
				moving_timer += 1
				var normallerper = lerp(global_position, global_position+direction*90, delta*7)  
				velocity = (normallerper - global_position)/delta  
				move_and_slide() 
				switcher = false
				if moving_timer > 200:
					match randi_range(1,6):
						1:
							direction = Vector2.LEFT 
							switcher = true
						2:
							direction = Vector2.RIGHT 
							switcher = true
						3:direction = Vector2.UP
						4:direction = Vector2.DOWN
						5:direction = Vector2(-1,-1).normalized()
						6:direction = Vector2(1,1).normalized()
					moving_timer = 0 
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
	new_target_pos = new_pos
	shell_mode = true
	shell_timer.start()
	can_move = false

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.3,0.5)
func _on_timer_2_timeout() -> void:
	can_chase = true
func _on_shell_timer_timeout() -> void:
	shell_mode = false
	#random direction
	match randi_range(1,4):
		1:direction = Vector2.LEFT
		2:direction = Vector2.RIGHT
		3:direction = Vector2.UP
		4:direction = Vector2.DOWN
	time = randf_range(0.5,2.5)
	time1 = randf_range(80,160)
	after_shell_move = true
#SIGNALS
func _on_detectopetronious_body_entered(body: Node2D) -> void:
	if body.is_in_group("shark"):
		hit_dat_wall = true
func _on_detectopetronious_body_exited(body: Node2D) -> void:
	if body.is_in_group("shark"):
		hit_dat_wall = false
func _on_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_detect = true
func _on_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_detect = false
