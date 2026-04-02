extends AnimatedSprite2D
@onready var music: Panel = $music


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("music"):
		music.show()
		Manager.emit_signal("change_pos",global_position)
