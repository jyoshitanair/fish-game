extends Button
@onready var button2: Button = $"../Button2"
@onready var button3: Button = $"../Button4"
@onready var button1: Button = $"."
@onready var button3alt: Button = $"."

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
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
#return
func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lore.tscn")
#actual settings
func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/actual-settings.tscn")
