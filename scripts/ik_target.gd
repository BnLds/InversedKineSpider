extends Marker3D

@onready var spider_bot = $".."
@onready var fl_init = $"../FrontLeftInit"
@onready var fr_init = $"../FrontRightInit"
@onready var bl_init = $"../BackLeftInit"
@onready var br_init = $"../BackRightInit"
@onready var fl_target = $"../FrontLeftIKTarget"
@onready var fr_target = $"../FrontRightIKTarget"
@onready var bl_target = $"../BackLeftIKTarget"
@onready var br_target = $"../BackRightIKTarget"

@export var step_target: Node3D
@export var step_distance: float = 3.0
@export var max_step_distance: float = 6.0


@export var adjacent_target : Node3D
@export var opposite_target : Node3D

var is_stepping := false

func _process(delta):
	if spider_bot.is_grounded && !is_stepping && !adjacent_target.is_stepping:
		if abs(global_position.distance_to(step_target.global_position)) < max_step_distance && abs(global_position.distance_to(step_target.global_position)) > step_distance:
			step()
			opposite_target.step()
	
	if spider_bot.is_falling:
		_fall()

func step():
	var target_position = step_target.global_position
	var half_way = (global_position + step_target.global_position) / 2
	is_stepping = true
	
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + owner.basis.y, 0.1)
	t.tween_property(self, "global_position", target_position, 0.1)
	t.tween_callback(func(): is_stepping = false)
	
func _fall():
	var target_position
	match name:
		fl_target.name:
			target_position = fl_init.global_position
		fr_target.name:
			target_position = fr_init.global_position
		bl_target.name:
			target_position = bl_init.global_position
		br_target.name:
			target_position = br_init.global_position
	
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", target_position, 0.1)
	
