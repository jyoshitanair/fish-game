extends Node2D
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
var attack_timer
func _ready() -> void:
	attack_timer = get_tree().current_scene.get_node("fish/attack_timer")
	texture_progress_bar.value = 0
func _process(delta: float) -> void:
	texture_progress_bar.value = attack_timer.time_left*40 #value from 0-2.5, scale by 40
