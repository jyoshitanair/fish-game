extends Button
@onready var button2: Button = $"../Button2"
@onready var button3: Button = $"../Button4"
@onready var button1: Button = $"."
@onready var button3alt: Button = $"."
@onready var buttonsubmit: Button = $"../Button"
@onready var line_edit: LineEdit = $"../LineEdit"
@onready var check_button: CheckButton = $"../CheckButton"
func _ready() -> void:
	if check_button: 
		check_button.button_pressed = Manager.toggled
##1
func _1on_mouse_entered() -> void:
	button1.add_theme_font_size_override("font_size",63)
	button1.add_theme_constant_override("outline_size", 9)
func _1on_mouse_exited() -> void:
	button1.add_theme_font_size_override("font_size",59)
	button1.add_theme_constant_override("outline_size", 0)
##2
func _2on_button_mouse_entered() -> void:
	button2.add_theme_font_size_override("font_size",63)
	button2.add_theme_constant_override("outline_size", 9)
func _2on_button_mouse_exited() -> void:
	button2.add_theme_font_size_override("font_size",59)
	button2.add_theme_constant_override("outline_size", 0)
##3 aka return
func _3on_button_3_mouse_entered() -> void:
	if button3:
		button3.add_theme_font_size_override("font_size",63)
		button3.add_theme_constant_override("outline_size", 9)
	else:
		button3alt.add_theme_font_size_override("font_size",63)
		button3alt.add_theme_constant_override("outline_size", 9)
		
func _3on_button_3_mouse_exited() -> void:
	if button3:
		button3.add_theme_font_size_override("font_size",59)
		button3.add_theme_constant_override("outline_size", 0)
	else:
		button3alt.add_theme_font_size_override("font_size",59)
		button3alt.add_theme_constant_override("outline_size", 0)

#lore
func _on_pressed() -> void:
	if Manager.paused:
		get_tree().change_scene_to_file("res://scenes/pause.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
#return
func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lore.tscn")
#actual settings
func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/actual-settings.tscn")
func _on_buttonsub_pressed() -> void:
	Manager.urname = line_edit.text

func _on_v_slider_value_changed(value: float) -> void:
	Manager.volume = value

func _on_option_button_item_selected(index: int) -> void:
	if index == 0: 
		Manager.music.stream = load("res://assets/music/normal.ogg")
	if index == 1:
		Manager.music.stream = load("res://assets/music/chrisdjyogi-vocaloid-electroswing-noir-creepy-alt-pop-439236.mp3")
	if index == 2:
		Manager.music.stream = load("res://assets/music/igorovsyannykov-underwater-audiopanther-311437.mp3")
	if index ==3: 
		Manager.music.stream = load("res://assets/music/kontraa-water-afro-pop-music-445661.mp3")

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Manager.toggled = true
	else:
		Manager.toggled = false
