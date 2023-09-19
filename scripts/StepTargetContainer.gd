extends Node3D

@export var offset: float = 20.0
@export var move_speed : float = 5.0

@onready var parent = get_parent_node_3d()
@onready var previous_position = parent.global_position
@onready var spider_bot = $".."

func _process(delta):
	if spider_bot.is_grounded:
		var velocity = parent.global_position - previous_position
		global_position = parent.global_position + velocity * offset
		previous_position = parent.global_position
		
	if spider_bot.is_falling:
		var target_basis = Utils._basis_from_normal(Vector3.UP)
		transform.basis = lerp(transform.basis, target_basis, move_speed * delta).orthonormalized()
		
