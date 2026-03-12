extends Control
var tween
@onready var panel_2: Panel = $Panel2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
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
