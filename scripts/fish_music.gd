extends Node2D
@onready var music: Panel = $music
@onready var timer: Timer = $Timer
@onready var shell_spawn: Marker2D = $shell_spawn
var shell_path  = preload("res://scenes/shell.tscn")
var new_spot = Vector2(0.0,0.0)
var direction = Vector2(0.0,0.0)
var velocity = Vector2(0.0,0.0)
var alive = true
var old_flip = false
var flip = false 
var can_move = true
const SPEED = 300.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = randf_range(0.2,0.5)
	music.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("music"):
		music.show()
		var shell = shell_path.instantiate()
		shell.global_position = shell_spawn.global_position
		get_parent().add_child(shell)
		Manager.emit_signal("change_pos",shell.global_position)
		can_move = false
		timer.start()
		shell.get_node("bubbles").playing = true
##MOVEVMENT INPUTS
	if can_move:
		velocity.x = direction.x * delta * SPEED #fps
		velocity.y = direction.y * delta * SPEED #fps
		if Input.is_action_pressed("left"):
			old_flip = false
			new_spot = velocity.x - SPEED
			velocity.x= lerp(velocity.x, new_spot, 0.05)
			direction = Vector2(0.0,0.0)
		if Input.is_action_pressed("right"):
			old_flip = true
			new_spot = velocity.x + SPEED
			velocity.x = lerp(velocity.x, new_spot, 0.05)
			direction = Vector2(0.0,0.0)
		##VELOCITY.Y woah mah god 
		if Input.is_action_pressed("down"):
			new_spot = velocity.y + SPEED
			velocity.y= lerp(velocity.y, new_spot, 0.05)
			direction = Vector2(0.0,0.0)
		if Input.is_action_pressed("up"):
			new_spot = velocity.y - SPEED
			velocity.y = lerp(velocity.y, new_spot, 0.05)
			direction = Vector2(0.0,0.0)
		if flip != old_flip: 
			scale.x *= -1
		flip = old_flip
		position += velocity

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.2,0.5)
	can_move = true
