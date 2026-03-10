extends Node2D
@onready var bar: Panel = $bar
@onready var label: Label = $Label
var old_health
var fish
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fish = get_tree().get_first_node_in_group("player")
	old_health = fish.health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fish.health != old_health:
		bar.size.x = fish.health * 1.8 #max of 100 makes it grand total of 180 px - the size of the bar in pxs
		label.text = "%s"%fish.health
