extends Node3D

@export var offset: float = 20.0

@onready var parent = get_parent_node_3d()
@onready var previous_position = parent.global_position
@onready var spider_bot = $".."

func _process(delta):
	if spider_bot.is_grounded:
		var velocity = parent.global_position - previous_position
		global_position = parent.global_position + velocity * offset
		previous_position = parent.global_position
