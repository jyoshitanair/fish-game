extends Control
#the goats
@onready var position_player: AnimatedSprite2D = $"erm-circle/SubViewportContainer/SubViewport/position_player"
@onready var camera: Camera2D = $"erm-circle/SubViewportContainer/SubViewport/mouse-cam"
@onready var player_camera: Camera2D = $"erm-circle/SubViewportContainer/SubViewport/position_player/Camera2D"
#ZOOM
var cur_zoom = Vector2.ONE
var new_zoom: Vector2 
var is_zooming = false
var is_on_mini_map = false
@export var zoom_change = Vector2(0.1,0.1)
#MOUSE
var mouse_position
#other
var old_position  = Vector2.ZERO
var fish_node
var world_size = Vector2(1152,648)
var minimap_size = Vector2(150,150)
#functions
func _ready() -> void: 
	camera.zoom = cur_zoom
	player_camera.make_current()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fish_node = get_tree().get_first_node_in_group("player")
	print("fishy cords %s"%fish_node.position)
	print("mini_map cords %s"%position_player.position)
	##player following
	if fish_node:
		#position_player.position = Vector2(
			#fish_node.position.x/world_size.x*minimap_size.x,
			#fish_node.position.y/world_size.y*minimap_size.y
		#)
		position_player.position = fish_node.position
		if not position_player.global_position == old_position:
			is_zooming = false
			old_position = position_player.global_position
	##zooom - if on mini-map
	if is_on_mini_map:
		if Input.is_action_just_pressed("zoom-in"):
			is_zooming = true
			camera.make_current()
			new_zoom.x = clamp(cur_zoom.x + zoom_change.x, 0.1, 3.0)
			new_zoom.y = clamp(cur_zoom.y + zoom_change.y, 0.1, 3.0)
			camera.zoom = new_zoom
			cur_zoom = new_zoom
			
		if Input.is_action_just_pressed("zoom-out"):
			is_zooming = true
			camera.make_current()
			new_zoom.x = clamp(cur_zoom.x - zoom_change.x, 0.1, 3.0)
			new_zoom.y = clamp(cur_zoom.y - zoom_change.y, 0.1, 3.0)
			camera.zoom = new_zoom
			cur_zoom = new_zoom
		##camera changer
		if Input.is_action_just_pressed("right-click"):
			print("right clickihg")
			camera.global_position = player_camera.global_position
			camera.zoom = Vector2(1.0,1.0)
		##check for which cam is current
	if not is_zooming: 
		player_camera.zoom = cur_zoom
		player_camera.make_current()
		
##mouse
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_on_mini_map: 
		mouse_position = camera.get_global_mouse_position()
		camera.global_position = mouse_position
		cur_zoom = camera.zoom
		return
	if event.is_action("click") and is_on_mini_map: 
		print("open big map")
		
##CHECK IF IN MINIMAP FIRST OFC
func _on_detection_for_mouse_mouse_entered() -> void:
	is_on_mini_map = true
func _on_detection_for_mouse_mouse_exited() -> void:
	is_on_mini_map = false
