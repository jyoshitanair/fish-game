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
var new_target_pos
var shell_mode = false
var health = 100.0
#defaults
var moving_timer = 0
var switcher = false
@onready var timer: Timer = $idle_wait_timer
@onready var chase_zone: Area2D = $chase_zone
@onready var raycast: RayCast2D = $RayCast2D
@onready var label: Label = $Panel/Label
@onready var flippernode: Node = $flipper

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	add_to_group("shark")
	start_position = global_position
	player = get_tree().get_first_node_in_group("player")
	timer.wait_time = randf_range(0.3,0.5)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if can_move:
		if target_pos:
			in_loop_timer += 1 
			var lerper = lerp(global_position,target_pos,1 - exp(-speed *delta))
			velocity = (lerper - global_position)/delta
			move_and_slide()
			can_chase = false
			if global_position.distance_to(target_pos)< 10.0 or in_loop_timer == 300:
				global_position = target_pos  
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
					var lerper3 = lerp(global_position,start_position,1 - exp(-6 *delta)) 
					velocity = (lerper3 - global_position)/delta
					move_and_slide()    
					if global_position.distance_to(start_position) <15:
						global_position = start_position
						retreating = false
			else:
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
				pass
			else:
				old_flip = flipper.x > 5.0            	
			if flip != old_flip: 
				flippernode.scale.x *= -1
			flip = old_flip
func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.3,0.5)
#SIGNALS
func _on_detectopetronious_body_entered(body: Node2D) -> void:
	if body.is_in_group("shark"):
		direction = -direction
func _on_detectopetronious_body_exited(body: Node2D) -> void:
	if body.is_in_group("shark"):
		direction = -direction
func _on_hitzone_area_entered(area: Area2D) -> void:
	if area.is_in_group("gun"):
		health -= randi_range(5,20)
		label.text = str(health)
		area.queue_free()
func _on_chase_zone_body_entered(body: Node2D) -> void:
	print("connect in")
	if body.is_in_group("player"):
		print("YER IN")
		can_detect = true
func _on_chase_zone_body_exited(body: Node2D) -> void:
	print("connect out")
	if body.is_in_group("player"):
		can_detect = false
