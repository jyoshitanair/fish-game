extends CharacterBody2D
#SIGNALS
signal clicked
##CONSTS
const SPEED = 300.0
const CHARGE_SPEED = 800.0
##VARS
var bullet_moving = false
var charging = false
var bubblegun = preload("res://scenes/bubblegun.tscn")
var new_spot = Vector2(0.0,0.0)
var direction = Vector2(-1.0,0.0)
var alive = true
var old_flip = false
var flip = false 
var speed
var health = 100.0
var boostbar = 0.0
var tween 
#STATES
var bullet_speed
var can_tween = true 
var can_boost = true
var can_charge = true
var change_timer = false
var attack = false
var can_move = true
var bullet
var sendoffdirection
var healthadder = 0.0
var can_heal = false
var one_shark_chase = false
var hud
##MY GOATS ON READY ONTOP
@onready var animated_sprite_2d: AnimatedSprite2D = $toflipnode/AnimatedSprite2D
@onready var boost_timer: Timer = $boost_timer
@onready var attack_timer: Timer = $attack_timer
@onready var hitonetimer: Timer = $hitonetimer
@onready var toflipnode: Node2D = $toflipnode

func _ready() -> void: 
	global_position = Manager.fish_position
	var hitzone = toflipnode.get_node("hitzone")
	hitzone.add_to_group("player")
	add_to_group("player")
	speed = SPEED
	velocity = Vector2(-1.0,0.0)
	await get_tree().process_frame
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print(boostbar)
	one_shark_chase = false
	##heal
	for shark in get_tree().get_nodes_in_group("shark"):
		if shark.can_detect:
			one_shark_chase = true
			break
	if one_shark_chase:
		can_heal = false
	else:
		can_heal = true
	if health < 100 and can_heal:
		healthadder += 4.0*delta
		if healthadder>= 1.0:
			health += int(healthadder)
			healthadder = 0.0
	if health <= 0.0:
		alive = false
		get_tree().change_scene_to_file("res://scenes/YouLose.tscn")
	velocity.x = direction.x * delta * speed #fps
	velocity.y = direction.y * delta * speed #fps

##MOVEVMENT INPUTS
	if can_move:
		velocity = Vector2.ZERO
		if Input.is_action_pressed("left"):
			new_spot = velocity.x - speed
			velocity.x= lerp(velocity.x, new_spot,delta*3)
			direction = Vector2(-1.0,0.0)
			old_flip = false
		if Input.is_action_pressed("right"):
			old_flip = true
			new_spot = velocity.x + speed
			velocity.x = lerp(velocity.x, new_spot, delta*3)
			direction = Vector2(1.0,0.0)
		##VELOCITY.Y woah mah god 
		if Input.is_action_pressed("down"):
			new_spot = velocity.y + speed
			velocity.y= lerp(velocity.y, new_spot, delta*3)
			direction = Vector2(0.0,1.0)
		if Input.is_action_pressed("up"):
			new_spot = velocity.y - speed
			velocity.y = lerp(velocity.y, new_spot, delta*3)
			direction = Vector2(0.0,-1.0)
		position += velocity
		if flip != old_flip: 
			toflipnode.scale.x *= -1
		flip = old_flip
	move_and_slide()
	#Speed up 
	if can_boost == true:
		emit_signal("clicked",false)
	else:
		emit_signal("clicked",true)
	if Input.is_action_pressed("boost"):
		if can_boost:
			speed = lerp(speed,500.0,delta*3)
			if speed >=450:
				can_boost= false
				speed = SPEED
				boost_timer.start()
	if Input.is_action_pressed("charge") and can_charge and !bullet_moving:
		if bullet == null:
			bullet = bubblegun.instantiate()
			get_tree().current_scene.add_child(bullet)
			charging = true
			bullet.global_position = global_position
		if charging:
			if is_instance_valid(bullet):
				bullet.global_position = global_position
			if can_tween == true:
				tweeny(Vector2(0.5,0.5),bullet.get_node_or_null("Sprite2D"))
				can_tween = false
			if boostbar <= 3.0: 
				boostbar += delta
			else:
				boostbar = 3.0
	if Input.is_action_just_released("charge") and boostbar != 0.0 and charging:
		if bullet: 
			bullet.boostbar = boostbar
			var timer = bullet.get_node_or_null("Timer")
			if bullet.is_inside_tree():
				timer.start()
		sendoffdirection = direction
		bullet_moving = true
		charging = false
		can_charge = false
		attack = true
		can_tween = true
		change_timer = true
		if tween != null: 
			tween.kill()
	####ATTACKINGeee
	if attack: 
		if direction == Vector2(0.0,0.0):
			direction = Vector2(-1.0,0.0)
		hitonetimer.start()
		if boostbar <= 0:
			boostbar = 0.0
		else:
			boostbar = clamp(boostbar, 0.5,3.0)
			var target_speed = clamp(500.0*boostbar,650.0,1000.0)
			bullet_speed = lerp(speed, target_speed,delta*3.0)
			if bullet:
				bullet.global_position += sendoffdirection *bullet_speed *delta
	if attack and (not is_instance_valid(bullet) or boostbar <=0.0):
		print("DEAD")
		attack = false
		bullet_moving = false
		can_move = true
		speed = SPEED
		boostbar = 0.0
		bullet  = null
		attack_timer.start()
	var hud = get_tree().get_first_node_in_group("BAR")
	if is_instance_valid(bullet):
		if hud: 
			hud.lock = true
	else:
		if hud: 
			hud.lock = false
func _on_boost_timer_timeout() -> void:
	change_timer= false
	can_boost = true
func tweeny(vector,bulletsprite) -> void: 
	var speed 
	tween = create_tween()
	tween.set_parallel(false)
	if vector == Vector2(0.5,0.5):
		speed = 3.0
	else: 
		speed= 0.04
	tween.tween_property(bulletsprite, "scale", vector, speed)

func _on_diemf_body_entered(body: Node2D) -> void:
	if body.is_in_group("shark"):
		randomize()
		if health - randi_range(20,40) <= 0:
			health = 0 
		else:
			health -= randi_range(20,40)
func _on_attack_timer_timeout() -> void:
	can_charge = true
