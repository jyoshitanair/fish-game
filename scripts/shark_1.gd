extends Area2D
var alr_won = false
@onready var mini_game: Node2D = $".."
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if!alr_won:
		if (
			#case 1 shark+ shark
			(Manager._2_on_pos_shark and Manager._1_on_pos_shark) or
			#case 2 shark+ player
			(Manager._2_on_pos_shark and Manager._1_on_pos_player) or
			(Manager._1_on_pos_shark and Manager._2_on_pos_player) or
			#case 3 shark+ shell
			(Manager._2_on_pos_shell and Manager._1_on_pos_shark) or
			(Manager._1_on_pos_shell and Manager._2_on_pos_shark) or
			#case 3 player+ player
			(Manager._1_on_pos_player and Manager._2_on_pos_player) or
			#case 3 player+ shell
			(Manager._2_on_pos_shell and Manager._1_on_pos_player) or
			(Manager._1_on_pos_shell and Manager._2_on_pos_player) or
			#case 4 shell+ shell
			(Manager._1_on_pos_shell and Manager._2_on_pos_shell) 
			
		):
			get_tree().change_scene_to_file("res://scenes/MiniGameRulesReturning.tscn")
		alr_won = true
#sark1
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Manager._1_on_pos_player = true
	if body.is_in_group("shark"):
		Manager._1_on_pos_shark = true
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		Manager._1_on_pos_player = false
	if body.is_in_group("shark"):
		Manager._1_on_pos_shark = false
#sarkdos
func _on_body_entered_2(body: Node2D) -> void:
	if body.is_in_group("player"):
		Manager._2_on_pos_player = true
	if body.is_in_group("shark"):
		Manager._2_on_pos_shark = true
func _on_body_exited_2(body: Node2D) -> void:
	if body.is_in_group("player"):
		Manager._2_on_pos_player = false
	if body.is_in_group("shark"):
		Manager._2_on_pos_shark = false
#sark1
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("shell"):
		Manager._1_on_pos_shell = true
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("shell"):
		Manager._1_on_pos_shell = false
#sark2
func _on_area_entered_2(area: Area2D) -> void:
	if area.is_in_group("shell"):
		Manager._2_on_pos_shell = true
func _on_area_exited_2(area: Area2D) -> void:
	if area.is_in_group("shell"):
		Manager._2_on_pos_shell = false
