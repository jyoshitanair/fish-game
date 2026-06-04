extends Node2D
var cur_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_node = get_tree().get_first_node_in_group(name)
	print(cur_node)
	if is_in_group("shark"):
		remove_from_group("shark")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = cur_node.global_position
