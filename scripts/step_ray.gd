extends RayCast3D

@onready var spider_bot = $"../../.."
@onready var fl_init = $"../../../FrontLeftInit"
@onready var bl_init = $"../../../BackLeftInit"
@onready var br_init = $"../../../BackRightInit"
@onready var fr_init = $"../../../FrontRightInit"
@onready var bl_step = $"../../BackLeftStepTarget"
@onready var fr_step = $"../../FrontRightStepTarget"
@onready var br_step = $"../../BackRightStepTarget"
@onready var fl_step = $"../../FrontLeftStepTarget"

@export var step_target : Node3D
@export var min_distance : float = 1.0
@export var max_distance : float = 2.0

func _physics_process(delta):
	if spider_bot.is_grounded:
		var hit_point = get_collision_point()
		if hit_point && hit_point.distance_to(step_target.global_position) > min_distance:
			if  hit_point.distance_to(step_target.global_position)<max_distance:
				step_target.global_position = hit_point
	if spider_bot.is_falling:
		_set_step_target_fall()
		
func _set_step_target_fall():
	var target_position
	match get_parent().name:
		fl_step.name:
			target_position = fl_init.global_position
		fr_step.name:
			target_position = fr_init.global_position
		bl_step.name:
			target_position = bl_init.global_position
		br_step.name:
			target_position = br_init.global_position
	
	step_target.global_position = target_position
