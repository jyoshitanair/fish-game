extends Node2D
#Manager vars for this section 
#var fish_mini_game_pos
#var shark1_mini_game_pos
#var shark2_mini_game_pos
#var shell_mini_game_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Manager.mini_game_paused = true
		Manager.fish_mini_game_pos = get_node("fish").global_position
		Manager.shark1_mini_game_pos = get_node("shark").global_position
		Manager.shark2_mini_game_pos = get_node("shark2").global_position
		var shell = get_tree().get_first_node_in_group("shell")
		if shell:
			Manager.shell_mini_game_pos = shell.global_position
		get_tree().change_scene_to_file("res://scenes/pause.tscn")
