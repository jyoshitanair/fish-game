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
#STATES
var is_attacking = false
var can_chase = false 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var hitzone = get_node("hitzone")
	hitzone.add_to_group("shark")
	add_to_group("shark")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	label.text = "%s"%health
	update_animations()
	##CONNECTING THE START CHASE ZONE
	var starts = start_chase_zone.get_overlapping_bodies()
	for start in starts:
		if start.is_in_group("player") and start.alive:
			if o == 0:
				timer.start()
				o = 1 
			#going left
			if scale.x > 0:
				attack_position.x -= 15.0
			else: 
				attack_position.x += 15.0
	##CONNECTING THE CHASE ZONE
	var chases = chase_zone.get_overlapping_bodies()
	if chases.size()==0:
		can_chase = false
		o = 0
	for chase in chases: 
		if chase.is_in_group("player") and chase.alive and can_chase:
			##finding position 
			##DISTANCE FORMULA = sqroot((x1-x2)^2 + (y1-y2)^2)
			var distance = global_position.distance_to(chase.global_position)
			speed = clamp(200/distance *400,650,1000)
			cur_speed = lerp(cur_speed,speed,delta*5)
			if not is_attacking:
				var direction = (chase.global_position - global_position).normalized()
				velocity = lerp(velocity, direction*speed, delta*10)
					##FLIPPING CALCS
				old_flip = direction.x > 0
				##ATTACK LOGIC
				if distance <= 600.0:
					attack_timer = 0.0
					is_attacking = true
					i = 0.1              
			#jolt                                           
			else: 
				attack_timer += delta
				i += (1.0 - i)*delta*0.07
				attack_position =chase.global_position +Vector2(sign(scale.x) *15, 0)
				var attack_dir = (attack_position - global_position).normalized()
				attack_dir.y = clamp(attack_dir.y, -0.3, 0.3)
				print(attack_dir)
				velocity = lerp(velocity, attack_dir*speed, i)
				if global_position.distance_to(attack_position)<=20 || attack_timer >= 2.00:
					print("no more attacking")
					attack_animation_play = true
					is_attacking = false
					i = 0.1	  				
	if flip != old_flip: 
		scale.x *= -1
	flip = old_flip
	if is_attacking:
		velocity.y = 0
	move_and_slide()
func update_animations() -> void: 
	if attack_animation_play:      
		sprite.play("attack")
		attack_animation_play = false
	elif can_chase:
		pass
		#print("detecting")
	else:
		sprite.play("idle")

func _on_idle_wait_timer_timeout() -> void:
	can_chase = true
func _on_jaw_zone_body_entered(body: Node2D) -> void:
	###
	pass
func _on_hitzone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_attacking:
		is_attacking = false
		body.health -= 5.0
###IN CASEEE I MEESSS UPPP
#label.text = "%s"%health
	#update_animations()
	###CONNECTING THE START CHASE ZONE
	#var starts = start_chase_zone.get_overlapping_bodies()
	#for start in starts:
		#if start.is_in_group("player") and start.alive:
			#if o == 0:
				#timer.start()
				#o = 1 
			##going left
			#if scale.x > 0:
				#attack_position.x -= 15.0
			#else: 
				#attack_position.x += 15.0
	###CONNECTING THE CHASE ZONE
	#var chases = chase_zone.get_overlapping_bodies()
	#if chases.size()==0:
		#can_chase = false
		#o = 0
	#for chase in chases: 
		#if chase.is_in_group("player") and chase.alive and can_chase:
			###finding position 
			###DISTANCE FORMULA = sqroot((x1-x2)^2 + (y1-y2)^2)
			#var direction = (chase.global_position - global_position).normalized()
			#var distance = global_position.distance_to(chase.global_position)
			#print(distance)
			#speed = clamp(3.0/distance *400,0.3,2.5)
			#cur_speed = lerp(cur_speed,speed,delta*2)
			#global_position = lerp(global_position, chase.global_position, 1 - exp(-cur_speed *delta))
				###FLIPPING CALCS
			#var flipper = chase.global_position - global_position # negative means on the left, positive means on the right
			#old_flip = flipper.x > 5.0
			###ATTACK LOGIC
			#if distance <= 600.0 and not is_attacking:
				#attack_timer = 0.0
				#is_attacking = true
				#attack_position =chase.global_position +Vector2(sign(scale.x) *15, 0)
				#i = 0.1              
					##jolt                                           
			#if is_attacking:  
				#attack_timer += delta
				#i += (1.0 - i)*delta*0.07
				#global_position = lerp(global_position, attack_position, i)
				#if global_position.distance_to(attack_position)<=20 || attack_timer >= 2.00:
					#attack_animation_play = true
					#is_attacking = false
					#i = 0.1	  				
	#if flip != old_flip: 
		#scale.x *= -1
	#flip = old_flip
	#move_and_slide()
