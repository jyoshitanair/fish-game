extends CharacterBody2D
#ON READYS 
@onready var chase_zone: Area2D = $chase_zone
@onready var raycast: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var start_chase_zone: Area2D = $start_chase_zone
@onready var timer: Timer = $idle_wait_timer
@onready var label: Label = $Panel/Label
#VARS
var health = 100.0
var attack_animation_play = false
var attack_timer = 0.0
var speed:float = 0.9
var cur_speed = 0.0
var old_flip = false
var flip = false  
var i = 0.1
var o = 0
var attack_position = Vector2.ZERO
var direction = Vector2(-1.0,1.0)
var start_position
var player
var can_move = true
var can_detect = false
#STATES
var retreating = false
var is_attacking = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var hitzone = get_node("hitzone")
	hitzone.add_to_group("shark")
	add_to_group("shark")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	label.text = "%s"%health
	update_animations()
	print(" can_detect:", can_detect)
	if can_move:
		if player and can_detect:   
			direction = (player.global_position - global_position).normalized()
			var distance = global_position.distance_to(player.global_position)
			speed = clamp(3.0/distance *400,0.3,10.5)
			cur_speed = lerp(cur_speed,speed,delta*2)   
			##ATTACK LOGIC
			if distance <= 600.0 and not is_attacking and not retreating:
				start_position = global_position
				attack_timer = 0.0
				is_attacking = true
				attack_position = player.global_position + Vector2(sign(direction.x) * 15, 0)
				i = 0.1      
			elif not is_attacking and not retreating:     
				velocity = direction*delta*600
				move_and_slide()                  
			if is_attacking: 
				attack_timer += delta
				i += (1.0 - i)*delta*0.07
				global_position = lerp(global_position, attack_position, i)
				if global_position.distance_to(attack_position)<=20 or attack_timer >= 7.00:
					attack_animation_play = true
					global_position = start_position
					is_attacking = false	
					retreating = true
			elif retreating: 
				print("retreat")  
				#direction = (player.global_position - global_position).normalized()
				#global_position = lerp(global_position,start_position,1 - exp(-6 *delta))
				if global_position.distance_to(start_position) <15:
					global_position = start_position
					retreating = false
	##FLIPPING CALCS
	if flip != old_flip: 
		scale.x *= -1 
		flip = old_flip 
	move_and_slide()

func update_animations() -> void: 
	if attack_animation_play:      
		sprite.play("attack")
		attack_animation_play = false
	else:
		sprite.play("idle")

func _on_idle_wait_timer_timeout() -> void:
	pass
func _on_jaw_zone_body_entered(body: Node2D) -> void:
	###
	pass
func _on_hitzone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_attacking:
		is_attacking = false
		body.health -= 5.0
func _on_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(body.name)
		can_detect = true
func _on_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_detect = false
