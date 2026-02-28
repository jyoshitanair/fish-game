extends Node2D
@onready var where_the_circle_is: Marker2D = $where_the_circle_is
@export var radius:float = 250.0
@export var width:float = 15.0
func _draw() -> void:
	z_index = 143
	var po =where_the_circle_is.position
	draw_arc(po,radius,0,2*PI,100,Color("93b4efff"),width,true) #border
	if name == "erm-circle":
		draw_circle(po,radius,Color.BLACK)
