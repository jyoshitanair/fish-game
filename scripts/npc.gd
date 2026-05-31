extends Node2D
@onready var call_area: Area2D = $"call-area"
@export var path: PackedScene
@onready var alert_area: Area2D = $"alert-area"
var group_name
var cur_name
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	call_deferred("_get_groups")
func _process(_delta: float) -> void:
	##FINDING PLAYER INTERACTIONS
	if Manager.get(cur_name) == true:
		var call_bodies = call_area.get_overlapping_bodies()
		for body in call_bodies:
			if body.is_in_group("player"):
				dialog_enter(body)
func dialog_enter(player) -> void: 
	##setting up the next
	var rest = group_name.substr(0,group_name.length()-1)
	var num:int = int(group_name.substr(group_name.length()-1,group_name.length()))
	num += 1
	if num == 2:
		Manager.text = "Goal: Find Finnegan"
	if num == 3:
		Manager.text = "Goal: Find the grumpy crab"
	if num == 4:
		if Manager.shark_mode:
			Manager.text = "Goal: Kill the Sharks to Find Bobu's Wife."
	if num ==5:
		Manager.text = "Goal: Return Bobu's Wife"
	if num == 7:
		num =1
	group_name = rest + str(num)
	if group_name == "npc3" and Manager.first_crab:
		group_name = "npc5"
	var name = "" +group_name + "_is_current"
	Manager.set(name,true)
	Manager.set(cur_name,false)
	Manager.fish_position = player.global_position
	get_tree().change_scene_to_packed(path)
func _on_alertarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("mc detected")
		_get_groups()
func _on_alertarea_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("mc left")
func _get_groups() -> void:
	group_name = self.get_groups()[0]
	##setting up the current
	if group_name == "npc3" and Manager.npc5_is_current:
		group_name = "npc5"
	cur_name = group_name + "_is_current"
	if Manager.get(cur_name) == true:
		if cur_name == "npc4_is_current":
			if Manager.shark_mode:
				#disable her for now
				visible = false
				alert_area.monitoring = false
				call_area.monitoring = false
				return
		alert_area.monitoring = true
		call_area.monitoring = true
	else:
		alert_area.monitoring = false
		call_area.monitoring = false
func reveal_npc4() ->void:
	visible = true 
	alert_area.monitoring = true
	call_area.monitoring = true
	var label = get_tree().current_scene.get_node("start").get_node("HUD").get_node("popup").get_node("text")
	label.text = "Goal: Find Bobu's Wife"
