extends AnimatedSprite2D
var target_pos = null
var speed = 6
var can_lerp = false
var player
var can_hear = false
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = randf_range(0.3,0.5)
	Manager.connect("change_pos",_change_target_pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_pos != null and can_hear:
		if can_lerp:
			global_position = lerp(global_position,target_pos,1 - exp(-speed *delta) )
		if global_position.distance_to(target_pos)< 10.0:
			global_position = target_pos
			can_lerp = false
func _change_target_pos(new_pos):
	timer.start()
	target_pos = new_pos 
	print(target_pos)

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.3,0.5)
	can_lerp = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("shell"):
		can_hear = true
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("shell"):
		can_hear = false
