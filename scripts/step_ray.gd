extends RayCast3D

@onready var spider_bot = $"../../.."

@export var step_target : Node3D
@export var min_distance : float = 1.0
@export var max_distance : float = 2.0

func _physics_process(delta):
	if spider_bot.is_grounded:
		var hit_point = get_collision_point()
		if hit_point && hit_point.distance_to(step_target.global_position) > min_distance:
			if  hit_point.distance_to(step_target.global_position)<max_distance:
				step_target.global_position = hit_point
