extends Control
#the goats
@onready var map: Node2D = $"erm-circle/SubViewportContainer/SubViewport/Startcopyforminimap"
@onready var sub_viewport: SubViewport = $"erm-circle/SubViewportContainer/SubViewport"
var position_player: AnimatedSprite2D
@onready var camera: Camera2D = $"erm-circle/SubViewportContainer/SubViewport/Startcopyforminimap/mouse-cam"
var player_camera: Camera2D
var manual = false
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
	position_player = get_tree().get_first_node_in_group("player_position")
	player_camera = position_player.get_node("Camera2D")
	camera.zoom = cur_zoom
	player_camera.make_current()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fish_node = get_tree().get_first_node_in_group("player")
	##player following
	if fish_node:
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
			clamp_them_limits(camera)
			
		if Input.is_action_just_pressed("zoom-out"):
			is_zooming = true
			camera.make_current()
			new_zoom.x = clamp(cur_zoom.x - zoom_change.x, 0.1, 3.0)
			new_zoom.y = clamp(cur_zoom.y - zoom_change.y, 0.1, 3.0)
			camera.zoom = new_zoom
			cur_zoom = new_zoom
			clamp_them_limits(camera)
		##camera changer
		if Input.is_action_just_pressed("right-click"):
			is_zooming = false
			manual = false
			camera.global_position = player_camera.global_position
			camera.zoom = Vector2(1.0,1.0)
			clamp_them_limits(camera)
		##check for which cam is current
	if not is_zooming and not manual: 
		player_camera.zoom = cur_zoom
		player_camera.make_current()
		
##mouse
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_on_mini_map: 
		manual = true
		mouse_position = camera.get_global_mouse_position()
		camera.global_position = mouse_position
		clamp_them_limits(camera)
		cur_zoom = camera.zoom
		return
##CHECK IF IN MINIMAP FIRST OFC
func _on_detection_for_mouse_mouse_entered() -> void:
	is_on_mini_map = true
func _on_detection_for_mouse_mouse_exited() -> void:
	is_on_mini_map = false
#i hate cameras. why do i even have two? this was so dumb
func clamp_them_limits(camera_cameras):
	#const MIN_X = -13000
	#const MAX_X = 13000
	#const MIN_Y = -2500
	#const MAX_Y = 9500
	var world_limits = Rect2(-13000,-2500, 26000, 12000 ) #x,y,width,height
	var view_size = Vector2(sub_viewport.size)/camera_cameras.zoom
	var map_origin = map.global_position
	var cam_pos = camera_cameras.global_position - map_origin
	var camerarect = Rect2(cam_pos - (view_size/2.0),view_size) #what the camera sees rn
	camerarect.position.x = clamp(camerarect.position.x,world_limits.position.x,world_limits.end.x - camerarect.size.x)
	camerarect.position.y = clamp(camerarect.position.y,world_limits.position.y,world_limits.end.y - camerarect.size.y)
	camera_cameras.global_position = camerarect.position + (camerarect.size / 2.0)
