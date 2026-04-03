extends AnimatedSprite2D
var target_pos = null
var speed = 0.5
var can_lerp = false
var can_hear = false
var player
var cur_speed = 0.0
var old_flip = false
var is_attacking = false
var attack_timer = 0.0
var attack_position = Vector2.ZERO
var i = 0.1
var flip = false  
@onready var timer: Timer = $Timer
@onready var raycast: RayCast2D = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player").get_parent()
	timer.wait_time = randf_range(0.3,0.5)
	Manager.connect("change_pos",_change_target_pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if raycast.can_see:
		##finding position 
		##DISTANCE FORMULA = sqroot((x1-x2)^2 + (y1-y2)^2)
		var direction = (player.global_position - global_position).normalized()
		var distance = global_position.distance_to(player.global_position)
		speed = clamp(3.0/distance *400,0.3,2.5)
		cur_speed = lerp(cur_speed,speed,delta*2)
		global_position = lerp(global_position, player.global_position, 1 - exp(-cur_speed *delta))
			##FLIPPING CALCS
		var flipper = player.global_position - global_position # negative means on the left, positive means on the right
		old_flip = flipper.x > 5.0
		##ATTACK LOGIC
		if distance <= 600.0 and not is_attacking:
			attack_timer = 0.0
			is_attacking = true
			attack_position =player.global_position +Vector2(sign(scale.x) *15, 0)
			i = 0.1              
				#jolt                                           
		if is_attacking:  
			attack_timer += delta
			i += (1.0 - i)*delta*0.07
			global_position = lerp(global_position, attack_position, i)
			if global_position.distance_to(attack_position)<=20 || attack_timer >= 7.00:
				#attack_animation_play = true
				is_attacking = false	
				direction = (player.global_position - global_position).normalized()
				target_pos = global_position +direction*800
				print(player.global_position)
				print(target_pos)
		if flip != old_flip: 
			scale.x *= -1
		flip = old_flip
	if target_pos != null and can_hear:
		if can_lerp:
			global_position = lerp(global_position,target_pos,1 - exp(-6 *delta) )
		if global_position.distance_to(target_pos)< 10.0:
			global_position = target_pos
			can_lerp = false
func _change_target_pos(new_pos):
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
