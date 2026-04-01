extends Control
var tween
@onready var panel_2: Panel = $Panel2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player 
	for p in get_tree().get_nodes_in_group("player"):
		if p is CharacterBody2D:
			player = p
	player.clicked.connect(Callable(self, "on_recieved"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fade(to_alpha) -> void:
	var tween := create_tween()
	tween.tween_property(panel_2, "modulate:a", to_alpha, 0.2)
	await tween.finished
func on_recieved(toF) -> void:
	if toF == false:
		fade(0)
	else:
		fade(1)
