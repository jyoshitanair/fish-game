extends Node2D
#SIGNALS
signal clicked
##CONSTS
const SPEED = 300.0
const CHARGE_SPEED = 800.0
##VARS
var new_spot = Vector2(0.0,0.0)
var velocity = Vector2(0.0,0.0)
var direction = Vector2(0.0,0.0)
var alive = true
var old_flip = false
var flip = false 
var speed
var health = 100.0
var boostbar = 0.0
var can_boost = true
##MY GOATS ON READY ONTOP
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var boost_timer: Timer = $boost_timer

func _ready() -> void: 
	add_to_group("player")
	speed = SPEED
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health == 0.0:
		alive = false
		get_tree().quit()
	velocity.x = direction.x * delta * speed #fps
	velocity.y = direction.y * delta * speed #fps

##MOVEVMENT INPUTS
	if Input.is_action_pressed("left"):
		new_spot = velocity.x - speed
		velocity.x= lerp(velocity.x, new_spot, 0.05)
		direction = Vector2(0.0,0.0)
		#animated_sprite_2d.flip_h = false
		old_flip = false
	if Input.is_action_pressed("right"):
		#animated_sprite_2d.flip_h = true
		old_flip = true
		new_spot = velocity.x + speed
		velocity.x = lerp(velocity.x, new_spot, 0.05)
		direction = Vector2(0.0,0.0)
	##VELOCITY.Y woah mah god 
	if Input.is_action_pressed("down"):
		new_spot = velocity.y + speed
		velocity.y= lerp(velocity.y, new_spot, 0.05)
		direction = Vector2(0.0,0.0)
	if Input.is_action_pressed("up"):
		new_spot = velocity.y - speed
		velocity.y = lerp(velocity.y, new_spot, 0.05)
		direction = Vector2(0.0,0.0)
	position += velocity
	if flip != old_flip: 
		scale.x *= -1
	flip = old_flip
	#Speed up 
	if can_boost == true:
		emit_signal("clicked",false)
	else:
		emit_signal("clicked",true)
	if Input.is_action_pressed("boost"):
		if can_boost:
			print(speed)
			speed = lerp(speed,500.0,delta*3)
			if speed >=450:
				can_boost= false
				speed = SPEED
				boost_timer.start()
	if Input.is_action_pressed("charge"):
		boostbar += delta
		print(animated_sprite_2d.scale)
		if animated_sprite_2d.scale < Vector2(0.5,0.5):
			animated_sprite_2d.scale += Vector2(0.02,0.02)
		if boostbar == 5.0:
			print("full")
		
func _on_boost_timer_timeout() -> void:
	print("timer out")
	can_boost = true
