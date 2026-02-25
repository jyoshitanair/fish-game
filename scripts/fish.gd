extends Node2D
##CONSTS
const SPEED = 30.0
##VARS
var new_spot = Vector2(0.0,0.0)
var velocity = Vector2(0.0,0.0)
var direction = Vector2(0.0,0.0)
##MY GOATS ON READY ONTOP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x = direction.x * delta * SPEED #fps
	velocity.y = direction.y * delta * SPEED #fps
	if Input.is_action_pressed("left"):
		print("left clicked")
		new_spot = velocity.x - SPEED
		print(new_spot)
		velocity.x= lerp(velocity.x, new_spot, 0.05)
		direction = Vector2(0.0,0.0)
	if Input.is_action_pressed("right"):
		print("right clicked ")
		new_spot = velocity.x + SPEED
		velocity.x = lerp(velocity.x, new_spot, 0.05)
		direction = Vector2(0.0,0.0)
	##VELOCITY.Y woah mah god 
	if Input.is_action_pressed("down"):
		print("down clicked")
		new_spot = velocity.y + SPEED
		velocity.y= lerp(velocity.y, new_spot, 0.05)
		direction = Vector2(0.0,0.0)
	if Input.is_action_pressed("up"):
		print("up clicked ")
		new_spot = velocity.y - SPEED
		velocity.y = lerp(velocity.y, new_spot, 0.05)
		direction = Vector2(0.0,0.0)
	position += velocity
