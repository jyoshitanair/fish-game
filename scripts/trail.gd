extends Line2D
var target_array = ["npc1",'npc2','npc3','npc4','npc5']
var target
var player
func _ready() -> void:
	print("spawn")
	width = 6
	for i in target_array:
		var path = i + "_is_current"
		if path == "npc5_is_current" and Manager.get(path):
			print("npc 5 current!")
			target = get_tree().get_first_node_in_group("npc3")
		if path == "npc4_is_current" and Manager.get(path):
			target = "shark"
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
	for child in get_children():
		if child.is_in_group("dynamic_shark"):
			remove_child(child)
			child.queue_free()
	if not player or not target:
		clear_points()
		return
	print(target)
	if target is String and target == "shark":
		clear_points()
		var sharks = get_tree().get_nodes_in_group("shark")
		if sharks.size() == 0:
			print("all dead")
			target = get_tree().get_first_node_in_group("npc4")
			Manager.shark_mode = false
			var npc4 = get_tree().get_first_node_in_group("npc4")
			npc4.reveal_npc4()
			return
		for shark in sharks: 
			var line = Line2D.new()
			line.z_index = 10
			line.width = 6
			line.default_color = Color.WHITE
			line.points = [player.global_position,shark.global_position]
			line.add_to_group("dynamic_shark")
			add_child(line)
	else:
		points = [ player.global_position,target.global_position]
