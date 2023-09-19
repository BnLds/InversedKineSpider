extends RayCast3D

@export var step_target : Node3D
@export var distance_threshold : float = 1.0

func _physics_process(delta):
	var hit_point = get_collision_point()
	if hit_point && hit_point.distance_to(step_target.global_position)>distance_threshold:
		step_target.global_position = hit_point
