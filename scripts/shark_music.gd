extends CharacterBody2D
var target_pos = null
var speed = 0.6
var can_lerp = false
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
var first_time = true
var direction
@onready var timer: Timer = $Timer
@onready var raycast: RayCast2D = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	player = get_tree().get_first_node_in_group("player")
	timer.wait_time = randf_range(0.3,0.5)
	Manager.connect("change_pos",_change_target_pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if target_pos and can_hear:
		if global_position.distance_to(target_pos)< 10.0:
			global_position = target_pos
			can_lerp = false      
	if raycast.can_see and player:    
		direction = (player.global_position - global_position).normalized()
		var distance = global_position.distance_to(player.global_position)
		speed = clamp(3.0/distance *400,0.3,2.5)
		cur_speed = lerp(cur_speed,speed,delta*2)   
		##ATTACK LOGIC
		if distance <= 600.0 and not is_attacking and not retreating:
			if first_time: 
				start_position = global_position
				first_time = false
			attack_timer = 0.0
			is_attacking = true
			attack_position =player.global_position +Vector2(sign(scale.x) *15, 0)
			i = 0.1                           
		if is_attacking:  
			attack_timer += delta
			i += (1.0 - i)*delta*0.07
			global_position = lerp(global_position, attack_position, i)
			if global_position.distance_to(attack_position)<=20 || attack_timer >= 7.00:
				#attack_animation_play = true
				global_position = start_position
				is_attacking = false	
				direction = (player.global_position - global_position).normalized()
				retreating = true
				first_time = false
		elif retreating: 
			direction = (player.global_position - global_position).normalized()
			global_position = lerp(global_position,start_position,1 - exp(-6 *delta))
			if global_position.distance_to(start_position) <15:
				global_position = start_position
				retreating = false
		else:
			direction = (player.global_position - global_position).normalized()
			global_position = lerp(global_position,player.global_position,1 - exp(-6 *delta))
		##FLIPPING CALCS
		var flipper = player.global_position - global_position # negative means on the left, positive means on the right
		old_flip = flipper.x > 5.0            	
		if flip != old_flip: 
			print(self)
			self.scale.x *= -1
		flip = old_flip
func _change_target_pos(new_pos):
	print("hi")
	timer.start()
	target_pos = new_pos 

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.3,0.5)
	can_lerp = true
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("shell"):
		can_hear = true
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("shell"):
		can_hear = false
