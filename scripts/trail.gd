extends Line2D
var target_array = ["npc1",'npc2','npc3','npc4','npc5']
var target
var player
func _ready() -> void:
	width = 6
	for i in target_array:
		var path = i + "_is_current"
		if path == "npc5_is_current" and Manager.get(path):
			target = get_tree().get_first_node_in_group("npc3")
		else:
			if Manager.get(path) == true:
				print(i)
				target = get_tree().get_first_node_in_group(i)
				print(target)
		var players = get_tree().get_nodes_in_group("player")
		for playeret in players:
			if playeret is CharacterBody2D:
				player = playeret
func _process(delta: float) -> void:
	if player and target:
		points = [ player.global_position,target.global_position]
			
