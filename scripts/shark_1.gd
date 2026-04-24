extends Area2D
var _1_on_pos = false
var _2_on_pos = false
var identity 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.get_groups()[0] == "load_1":
		identity = 1
	else:
		identity = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var whatscolliding = get_overlapping_bodies()
	for collider in whatscolliding:
		var groups  = collider.get_groups()
		if groups.size()>0 and groups[0] == "shell":
			print("well well")
			if identity == 1:
				_1_on_pos = true
				print("on one")
			else:
				_2_on_pos = true
				print("on two")
				
		else:
			_1_on_pos = false
			_2_on_pos = false
	#verify
