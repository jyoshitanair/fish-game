extends Node2D
var file = preload("res://scenes/cutscenes/cut_scene2.tscn")
var dialog
var change_to_go_left = false
var in_shark_zone = false
@onready var text: Label = $HUD/popup/text
@onready var area_2d: Area2D = $border
@onready var sharkzone: Panel = $HUD/sharkzone
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Manager.returning_from_mini_game: 
		var sharks = get_tree().get_nodes_in_group("shark")
		for shark in sharks:
			if Manager.alive_shark_array.has(shark.get_groups()[1]):
				Manager.alive_shark_array.erase(shark.get_groups()[1])
			shark.queue_free()
		var wifey = get_tree().get_first_node_in_group("npc4")
		wifey.queue_free()
		var trail = self.get_node("trail")
		trail.target = self.get_node("npc3")
	if in_shark_zone: 
		sharkzone.visible = true
	var player = get_tree().get_first_node_in_group("player")
	player.can_move = false
	if Manager.first_time:
		Manager.alive_shark_array.clear()
		for shark in get_tree().get_nodes_in_group("shark"):
			var s = shark.get_groups()[1]
			if not Manager.alive_shark_array.has(s):
				Manager.alive_shark_array.append(s)
		call_deferred("setting_up_dialog")
		Manager.first_time = false
	else:
		text.text = Manager.text
		player.can_move = true
	call_deferred("delete_him")
func delete_him() -> void:
	if get_tree() == null:
		return 
	await get_tree().process_frame
	if not Manager.returning_from_mini_game:
		for shark in get_tree().get_nodes_in_group("shark"):
			if not Manager.alive_shark_array.has(shark.get_groups()[1]):
				shark.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Manager.paused = true
		Manager.fish_health = get_tree().get_first_node_in_group("player").health
		Manager.fish_position = get_tree().get_first_node_in_group("player").global_position
		for shark in get_tree().get_nodes_in_group("shark"):
			var name = shark.get_groups()[1]
			var group_health = "%s_health"%name
			var group_pos = "%s_position"%name
			Manager.set(group_pos, shark.global_position)
			Manager.set(group_health, shark.health)
		get_tree().change_scene_to_file("res://scenes/pause.tscn")
	if in_shark_zone: 
		sharkzone.visible = true
func setting_up_dialog() -> void: 
	get_tree().change_scene_to_packed(file)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sharkzone.visible = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		sharkzone.visible = false
