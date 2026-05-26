extends Button
@onready var button1: Button = $"."
@onready var button2: Button = $"../Button"
@onready var button3: Button = $"../Button3"
#ah i also handle buttons clicks here. ig that filie name was pretty dumb oops
func _1on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
##1
func _1on_mouse_entered() -> void:
	button1.add_theme_font_size_override("font_size",43)
	button1.add_theme_constant_override("outline_size", 5)
func _1on_mouse_exited() -> void:
	button1.add_theme_font_size_override("font_size",38)
	button1.add_theme_constant_override("outline_size", 0)
##2
func _2on_button_mouse_entered() -> void:
	button2.add_theme_font_size_override("font_size",43)
	button2.add_theme_constant_override("outline_size", 5)
func _2on_button_mouse_exited() -> void:
	button2.add_theme_font_size_override("font_size",38)
	button2.add_theme_constant_override("outline_size", 0)
##3
func _3on_button_3_mouse_entered() -> void:
	button3.add_theme_font_size_override("font_size",43)
	button3.add_theme_constant_override("outline_size", 5)
func _3on_button_3_mouse_exited() -> void:
	button3.add_theme_font_size_override("font_size",38)
	button3.add_theme_constant_override("outline_size", 0)
