extends Node2D
@onready var call_area: Area2D = $"call-area"
var is_colliding_first_time = false
@onready var path = preload("res://scenes/cut_scene1.tscn")
@onready var level_root: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	##FINDING PLAYER INTERACTIONS
	var call_bodies = call_area.get_overlapping_areas()
	for body in call_bodies:
		if body.is_in_group("player"):
			print(body.name)
			dialog_enter()


func _on_alertarea_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("mc detected")

func _on_alertarea_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("mc left")
func dialog_enter() -> void: 
	var cut_scene1 = path.instantiate()
	level_root.queue_free()
	var main = get_tree().current_scene
	main.add_child(cut_scene1)
	
	
