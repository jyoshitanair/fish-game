extends CharacterBody2D
@onready var shell_spawn: Marker2D = $to_flip/shell_spawn
@onready var timer: Timer = $Timer
@onready var to_flip: Node = $to_flip
var shell_path  = preload("res://scenes/shell.tscn")
var direction = Vector2(0.0,0.0)
var alive = true
var old_flip = false
var flip = false 
var can_move = true
const speed = 1000.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Manager.fish_mini_game_pos
	timer.wait_time = randf_range(0.2,0.5)
	if Manager.shell_mini_game_pos != null:
		call_deferred("spawn_shell",Manager.shell_mini_game_pos)
		Manager.shell_mini_game_pos = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if alive:
		if Input.is_action_just_pressed("music"):
			var shells = get_tree().get_nodes_in_group("shell")
			if shells.size() >0:
				for shell in shells:
					shell.get_parent().queue_free()
			spawn_shell(shell_spawn.global_position)
	##MOVEVMENT INPUTS
		if can_move:
			direction = Vector2.ZERO
			if Input.is_action_pressed("left"):
				direction.x = -1.0
				old_flip = false
			if Input.is_action_pressed("right"):
				old_flip = true
				direction.x = 1.0
			##VELOCITY.Y woah mah god 
			if Input.is_action_pressed("down"):
				direction.y = 1.0
			if Input.is_action_pressed("up"):
				direction.y = -1.0
			#computations oohhh	
			direction = direction.normalized()
			velocity = velocity.lerp(direction*speed, delta*100)
			move_and_slide()
			if flip != old_flip: 
				to_flip.scale.x *= -1
			flip = old_flip

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.2,0.5)
	can_move = true


func _on_oohibeingdetected_area_entered(area: Area2D) -> void:
	if area.is_in_group("shark-area"):
		get_tree().change_scene_to_file("res://scenes/minigame-fail.tscn")
func spawn_shell(spawn_position)->void: 
	var shell = shell_path.instantiate()
	shell.global_position = spawn_position
	get_parent().add_child(shell)
	Manager.emit_signal("change_pos",shell.global_position)
	can_move = false
	timer.start()
	shell.get_node("bubbles").playing = true
