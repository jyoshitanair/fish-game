extends Node2D
#ON READYS 
@onready var chase_zone: Area2D = $chase_zone
@onready var raycast: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED_REGULAR = 1.4
const SPEED_FAST = 3.2
const SPEED_MEDIUM = 2.4
var speed = 1.0
var old_flip = false
var flip = false  
var i = 0.1
#STATES
var is_attacking = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("shark")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	update_animations()
	##CONNECTING THE CHASE ZONE
	var chases = chase_zone.get_overlapping_areas()
	for chase in chases:
		if chase.is_in_group("player") and chase.alive:
			##finding position 
			##DISTANCE FORMULA = sqroot((x1-x2)^2 + (y1-y2)^2)
			var distance = global_position.distance_to(chase.global_position)
			#TOTAL DISTANCE = 950
			if distance >= 700.0:
				speed = SPEED_REGULAR
			elif distance >= 400.0:
				speed = SPEED_MEDIUM
			elif distance >= 340.0:
				speed = SPEED_FAST
				##FLIPPING CALCS
			var flipper = chase.global_position - global_position # negative means on the left, positive means on the right
			if flipper.x <= 5.0: 
				old_flip = false
			else: 
				old_flip = true
			if distance <= 290.0:
				is_attacking = true
				#jolt 
				i = 1.0 * (1.0-exp(-1.0*i))
				global_position = lerp(global_position, chase.global_position, i)
			else:
				i = 0.1
				is_attacking = false
			##position moving towards
			global_position = lerp(global_position, chase.global_position, 1- exp(-speed*delta))
	if flip != old_flip: 
		scale.x *= -1
	flip = old_flip
func update_animations() -> void: 
	if is_attacking: 
		sprite.play("attack")
	else:
		sprite.play("idle")
