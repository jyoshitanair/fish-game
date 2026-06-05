extends Node2D
var cur_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 10000
	cur_node = get_tree().get_first_node_in_group(name)
	if cur_node.is_in_group("npc1")or cur_node.is_in_group("npc2") or cur_node.is_in_group("npc3") or cur_node.is_in_group("npc4"):
		var original_size = self.texture.get_size()
		var x = 250/original_size.x
		var y = 150/original_size.y
		scale = Vector2(x,y)
	else:
		scale = Vector2(0.3,0.3)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cur_node:
		self.position = cur_node.position
	else:
		queue_free()
