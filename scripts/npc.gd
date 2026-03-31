extends Node2D
@onready var call_area: Area2D = $"call-area"
var is_colliding_first_time = false
@export var path = preload("res://scenes/cutscenes/cut_scene1.tscn")
@onready var level_root: Node2D = $".."
var is_current = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	if self.is_in_group("npc2"):
		is_current = true
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
	print("change")
	get_tree().change_scene_to_packed(path)
	
	
