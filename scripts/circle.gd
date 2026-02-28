extends Node2D
@onready var where_the_circle_is: Marker2D = $where_the_circle_is

func _draw() -> void:
	z_index = 143
	var po =where_the_circle_is.position
	draw_circle(po,25,Color.BLACK)
	draw_arc(po,25,0,2*PI,100,Color.WHITE,true)
