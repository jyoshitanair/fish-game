extends CharacterBody2D
#SIGNALS
signal clicked
##CONSTS
const SPEED = 300.0
const CHARGE_SPEED = 800.0
##VARS
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
var can_tween = true 
var can_boost = true
var can_charge = true
var change_timer = false
var attack = false
var can_move = true
var hitzone_valid = false
##MY GOATS ON READY ONTOP
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var boost_timer: Timer = $boost_timer
@onready var attack_timer: Timer = $attack_timer
@onready var hitonetimer: Timer = $hitonetimer
@onready var label: Label = $"../../HUD/Label"

func _ready() -> void: 
	var hitzone = get_node("hitzone")
	hitzone.add_to_group("player")
	print(hitzone.get_groups())
	add_to_group("player")
	speed = SPEED
	label.text = "%s"%attack_timer.wait_time
	velocity = Vector2(-1.0,0.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if change_timer: 
		label.text = "%s"%attack_timer.time_left
	if health == 0.0:
		alive = false
		get_tree().quit()
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
			scale.x *= -1
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
	if Input.is_action_pressed("charge") and can_charge:
		can_move = false
		if can_tween == true:
			tweeny(Vector2(0.5,0.5))
			can_tween = false
		if boostbar >= 3.0: 
			print("full")
		else: 
			boostbar += delta
	if Input.is_action_just_released("charge"):
		can_charge = false
		attack = true
		can_tween = true
		change_timer = true
		attack_timer.start()
		if tween != null: 
			tween.kill()
		tweeny(Vector2(0.25,0.25))
	####ATTACKING
	if attack: 
		if direction == Vector2(0.0,0.0):
			direction = Vector2(-1.0,0.0)
		hitzone_valid = true
		hitonetimer.start()
		if boostbar <= 0:
			boostbar = 0.0
			attack = false
			can_move = true
			speed = SPEED
			velocity = Vector2(0.0,0.0)
		else:
			speed = lerp(speed,500.0*boostbar,delta*(3*boostbar))
			speed = clamp(speed,650.0,1000.0)
			new_spot = direction * speed
			position += velocity
			boostbar -= delta
func _on_boost_timer_timeout() -> void:
	change_timer= false
	can_boost = true
func tweeny(vector) -> void: 
	var speed 
	tween = create_tween()
	if vector == Vector2(0.5,0.5):
		speed = 3.0
	else: 
		speed= 0.04
	tween.tween_property(animated_sprite_2d, "scale", vector, speed)

func _on_attack_timer_timeout() -> void:
	can_charge = true 

func _on_hitonetimer_timeout() -> void:
	pass
	#hitzone_valid = false 

func _on_detection_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
func _on_hitzone_area_entered(area: Area2D) -> void:
	print("area hit")
	print(area.name)
	print(area.get_groups())
	print(hitzone_valid)
	if area.is_in_group("shark") and hitzone_valid:
		print("area hit")
		area.get_parent().health -= 5
