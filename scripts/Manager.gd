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
var music
func _ready() -> void:
	music = get_tree().get_first_node_in_group("music")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !music.playing and music:
		music.play()
