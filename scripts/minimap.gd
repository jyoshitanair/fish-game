extends Control
#the goats
@onready var position_player: AnimatedSprite2D = $"erm-circle/SubViewportContainer/SubViewport/position_player"
@onready var camera: Camera2D = $"erm-circle/SubViewportContainer/SubViewport/mouse-cam"
@onready var player_camera: Camera2D = $"erm-circle/SubViewportContainer/SubViewport/position_player/Camera2D"

#ZOOM
var cur_zoom = Vector2(1.0,1.0)
var new_zoom: Vector2 
var is_zooming = false
var is_on_mini_map = false
@export var zoom_change = Vector2(0.1,0.1)
#MOUSE
var mouse_position

var fish_node
func _ready() -> void: 
	camera.zoom = cur_zoom
	player_camera.make_current()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	##player following
	fish_node = get_tree().get_first_node_in_group("player")
	if fish_node:
		position_player.global_position = fish_node.global_position
	##zooom - if on mini-map
	if is_on_mini_map:
		if Input.is_action_just_pressed("zoom-in"):
			is_zooming = true
			new_zoom.x = clamp(cur_zoom.x + zoom_change.x, 0.1, 3.0)
			new_zoom.y = clamp(cur_zoom.y + zoom_change.y, 0.1, 3.0)
			camera.zoom = new_zoom
			cur_zoom = new_zoom
			
		if Input.is_action_just_pressed("zoom-out"):
			is_zooming = true
			new_zoom.x = clamp(cur_zoom.x - zoom_change.x, 0.1, 3.0)
			new_zoom.y = clamp(cur_zoom.y - zoom_change.y, 0.1, 3.0)
			camera.zoom = new_zoom
			cur_zoom = new_zoom
		##camera changer
		if Input.is_action_just_pressed("right-click"):
			camera.global_position = player_camera.global_position
			camera.zoom = Vector2(1.0,1.0)
		##check for which cam is current
		if is_zooming: 
			camera.make_current()
		else: 
			player_camera.make_current()
		
##mouse
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_on_mini_map: 
		print(mouse_position)
		mouse_position = camera.get_global_mouse_position()
		camera.global_position = mouse_position
		cur_zoom = camera.zoom


##CHECK IF IN MINIMAP FIRST OFC
func _on_area_2d_mouse_entered() -> void:
	is_on_mini_map = true
func _on_area_2d_mouse_exited() -> void:
	is_on_mini_map = false
