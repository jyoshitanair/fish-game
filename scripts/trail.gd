extends Line2D
@onready var target_1: Node2D = $"../npc"
@onready var target_2: Node2D = $"../npc2"
@onready var target_3: Node2D = $"../npc3"
var target_array = []
var target
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	target_array += [target_1,target_2,target_3]
func _process(delta: float) -> void:
	width = 6
	for i in target_array:
		if i.is_current:
			target = i
	if player and target:
		print("found!")
		points = [ player.global_position,target.global_position]
			
