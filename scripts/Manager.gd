extends Node

#signals 
signal change_pos
#sark 
var doneonce = true
var volume = 0
var _1_on_pos_player = false
var _1_on_pos_shell = false
var _1_on_pos_shark = false
var _2_on_pos_player = false
var _2_on_pos_shell = false
var _2_on_pos_shark = false
#vars
var returning_from_mini_game = false
var shark_mode = true
var previstream
var urname = "honored one"
var first_crab = false
var first_time = true
var npc1_is_current = true
var npc2_is_current = false
var npc3_is_current = false
var npc4_is_current = false
var npc5_is_current = false
var npc6_is_current = false
var fish_position = Vector2(903,399)
var text = "Goal: Talk to the Other Fish"
var music
func _ready() -> void:
	music = AudioStreamPlayer.new()
	add_child(music)
	music.autoplay = false
	music.stream = preload("res://assets/music/normal.ogg")
	music.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	music.volume_db = volume
	if !music.playing and music:
		music.play()	
	if get_tree().current_scene and get_tree().current_scene.is_in_group("minigamer") and doneonce:
		music.stop()
		previstream = Manager.music.stream
		music.stream = load("res://assets/music/base-mini-game-music.ogg")
		music.play()
		doneonce = false
	if !doneonce and get_tree().current_scene and !get_tree().current_scene.is_in_group("minigamer"):
		music.stop()
		music.stream = previstream
		music.play()
		doneonce = true
