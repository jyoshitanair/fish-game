extends CharacterBody2D
@onready var music: Panel = $to_flip/music
@onready var shell_spawn: Marker2D = $to_flip/shell_spawn
@onready var timer: Timer = $Timer
@onready var to_flip: Node = $to_flip
var shell_path  = preload("res://scenes/shell.tscn")
var new_spot = Vector2(0.0,0.0)
var direction = Vector2(0.0,0.0)
var alive = true
var old_flip = false
var flip = false 
var can_move = true
const speed = 300.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = randf_range(0.2,0.5)
	music.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("music"):
		music.show()
		var shells = get_tree().get_nodes_in_group("shell")
		if shells.size() >0:
			for shell in shells:
				shell.get_parent().queue_free()
		var shell = shell_path.instantiate()
		shell.global_position = shell_spawn.global_position
		get_parent().add_child(shell)
		Manager.emit_signal("change_pos",shell.global_position)
		can_move = false
		timer.start()
		shell.get_node("bubbles").playing = true
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
			to_flip.scale.x *= -1
		flip = old_flip
	move_and_slide()

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.2,0.5)
	can_move = true
