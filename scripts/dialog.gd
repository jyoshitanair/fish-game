extends Node2D
@export var dialog_array = [
	"this is some random text to see how the tet box works and if it will work like how i want it sto blah balh . dahfjkdhsflahsdf asdljfhasdljkfhaldhflkjadshfjhskdjfhskldfhjsdhfaajklshfjkahlskdjfasdklhfjdshkfjlsd", 
	"HI",
	"The name's bob", 
	"Nice to meet ya fishy"
	]
@export var fish_name = "bob"
var tween 
var duration
var base_time = 0.5
var per_letter_time = 0.06
var index = 0 
var count = 0 
var just_pressed = false
var flag_change = false
##GOAT ON READY
@onready var text: RichTextLabel = $Panel/Panel/text
@onready var timer: Timer = $Timer
@onready var label: RichTextLabel = $"Panel/char-name/Label"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Manager.npc6_is_current and Manager.first_dialog:
		dialog_array = [
			"Oh! You actually made it back! I thought the sharks wouldda gotten you for sure",
			"Perhaps...you won't die out there. But just PERHAPS",
			"Alright then. Here's a map for you. I hope you don't die ...or whatever. Not like I care.",
			"Good luck I guess."
		]
		Manager.first_dialog = false
		flag_change = true 
	label.text = fish_name
	just_pressed = true
	text.text = ""
	await get_tree().create_timer(0.5).timeout
	text.text = dialog_array[index]
	text.visible_ratio = 0.0
	index += 1
	just_pressed = false
	load_next_text()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		if not just_pressed:
			just_pressed = true
			timer.start()
			if count == 0:
				count += 1
				tween.kill()
				text.visible_ratio = 1.0
				return
			if count == 1:
				count -= 1
				if index < dialog_array.size():
					text.text = dialog_array[index]
					text.visible_ratio = 0.0
					index += 1
					load_next_text()
				else:
					if dialog_array[1] == "AHH! Oh my god I though you were going to eat me but thank god you're just a fish...are you here to save me?":
						Manager.first_crab = true
					_return()
func load_next_text() -> void: 
	tween = create_tween()
	duration = base_time + (per_letter_time * text.text.length())
	tween.tween_property(text,"visible_ratio",1.0,duration) # sprite,element,end-goal,duration
	await tween.finished

func _on_timer_timeout() -> void:
	just_pressed = false
func _return() ->void: 
	if flag_change: 
		get_tree().change_scene_to_file("res://scenes/map_game.tscn")
		return
	if is_in_group("minigame_rules"):
		get_tree().change_scene_to_file("res://scenes/mini_game.tscn")	
		return
	if is_in_group("minigame_rules_returning"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")	
		Manager.returning_from_mini_game = true
		return
	if is_in_group("minigame"):
		if Manager.npc6_is_current:
			get_tree().change_scene_to_file("res://scenes/map_game.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/mini_game_rules.tscn")	
		return
	if is_in_group("theend"):
		get_tree().change_scene_to_file("res://scenes/you win.tscn")
		return
	get_tree().change_scene_to_file("res://scenes/main.tscn")
