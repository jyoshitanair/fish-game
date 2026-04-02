extends Node
#signals 
signal change_pos
#vars
var first_time = true
var npc1_is_current = true
var npc2_is_current = false
var npc3_is_current = false
var npc4_is_current = false
var fish_position = Vector2(903,399)
var text = "Goal: Talk to the Other Fish"
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
