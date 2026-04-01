extends Node2D
@onready var call_area: Area2D = $"call-area"
@export var path: PackedScene
@onready var alert_area: Area2D = $"alert-area"
var talked = false 
var group_name
var manager_var 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	call_deferred("_get_groups")
func _process(_delta: float) -> void:
	##FINDING PLAYER INTERACTIONS
	if not talked: 
		var call_bodies = call_area.get_overlapping_bodies()
		for body in call_bodies:
			if body.is_in_group("player"):
				print(body.name)
				dialog_enter()
func dialog_enter() -> void: 
	##setting up the next
	var rest = group_name.substr(0,group_name.length()-1)
	var num:int = int(group_name.substr(group_name.length()-1,group_name.length()))
	num += 1
	if num == 4:
		get_tree().quit()
	group_name = rest + str(num)
	print(group_name)
	var name = "" +group_name + "_is_current"
	print(name)
	Manager.set(name,true)
	get_tree().change_scene_to_packed(path)
func _on_alertarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("mc detected")
func _on_alertarea_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("mc left")
func _get_groups() -> void:
	group_name = self.get_groups()[0]
	manager_var = "" +group_name + "_talked"
	if Manager.get(manager_var):
		talked = true 
	##setting up the current
	var cur_name = group_name + "_is_current"
	if Manager.get(cur_name) ==false:
		alert_area.monitoring = false
		call_area.monitoring = false
		Manager.set(manager_var, true)
