extends Node2D
##CONSTS
const SPEED = 300.0
##VARS
var new_spot = Vector2(0.0,0.0)
var velocity = Vector2(0.0,0.0)
var direction = Vector2(0.0,0.0)
var alive = true
var old_flip = false
var flip = false 
var speed
var health = 100.0
##MY GOATS ON READY ONTOP
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
	if Input.is_action_pressed("boost"):
		speed = 500.0
		await get_tree().create_timer(0.5).timeout
		speed = SPEED
