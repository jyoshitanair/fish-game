extends RayCast2D
var player 
var can_see = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	#THINGS TO DETECT GO ON LAYER 2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player:
		target_position = to_local(player.global_position)
		force_raycast_update()
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("player"):
			can_see = true
