extends Node2D
var file = preload("res://scenes/cutscenes/cut_scene2.tscn")
var dialog
var change_to_go_left = false
@onready var text: Label = $HUD/popup/text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.can_move = false
	if Manager.first_time:
		call_deferred("setting_up_dialog")
		Manager.first_time = false
	else:
		text.text = Manager.text
		player.can_move = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func setting_up_dialog() -> void: 
	get_tree().change_scene_to_packed(file)
