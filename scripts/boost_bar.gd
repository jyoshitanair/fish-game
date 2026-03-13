extends Node2D
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
var attack_timer
func _ready() -> void:
	attack_timer = get_tree().get_first_node_in_group("player").attack_timer
	texture_progress_bar.value = 0
func _process(delta: float) -> void:
	#if texture_progress_bar.value == 100:
		#texture_progress_bar.value = 0
	texture_progress_bar.value = attack_timer.time_left*40 #value from 0-2.5, scale by 40
	print(texture_progress_bar.value )
