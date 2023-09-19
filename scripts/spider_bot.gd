extends Node3D

const GRAVITY = -1

@export var move_speed : float = 5.0
@export var turn_speed : float = 1.0
@export var jump_amplitude : float = 10.0
@export var jump_speed : float = 3.0
@export var ground_offset : float = 2.0

@onready var fl_leg = $FrontLeftIKTarget
@onready var fr_leg = $FrontRightIKTarget
@onready var bl_leg = $BackLeftIKTarget
@onready var br_leg = $BackRightIKTarget
@onready var grounded_raycast = $GroundedRayCast


var is_grounded := true
var is_jumping := false
var is_falling := false
var target_jump_pos := Vector3.ZERO 
var fall_velocity : float = 0.0

func _process(delta):
	if is_falling && grounded_raycast.is_colliding():
		is_falling = false
		is_grounded = true
		
	if is_jumping:
		is_grounded = false
		position = lerp(position, position + transform.basis.y * jump_amplitude, jump_speed * delta)
		if position.distance_to(target_jump_pos) < 0.1:
			is_jumping = false
			is_falling = true
			
	if is_falling:
		fall_velocity += GRAVITY * delta
		translate(Vector3.UP * fall_velocity)
		
	if is_grounded:
		fall_velocity = 0
		
		"""Make the body normal aligned to the surface normal"""
		var plane1 = Plane(bl_leg.global_position, fl_leg.global_position, fr_leg.global_position)
		var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg.global_position)
		var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
		var target_basis = _basis_from_normal(avg_normal)
		transform.basis = lerp(transform.basis, target_basis, move_speed * delta).orthonormalized()
		
		"""Ensure the spider body is always at the same distance from the ground"""
		var avg_leg_position = (fl_leg.position + fr_leg.position + bl_leg.position + br_leg.position) / 4
		var target_pos = avg_leg_position + transform.basis.y * ground_offset
		var distance = transform.basis.y.dot(target_pos - position)
		position = lerp(position, position + transform.basis.y * distance, move_speed * delta)
		
		_handle_movement(delta)

func _handle_movement(delta):
	var direction = Input.get_axis("backward", "forward")
	translate(Vector3(0,0, - direction) * move_speed * delta)
	
	var angular_direction = Input.get_axis("right", "left")
	rotate_object_local(Vector3.UP, angular_direction * turn_speed * delta)
	
	if Input.is_action_pressed("jump") && !is_jumping && is_grounded:
		target_jump_pos =  position + transform.basis.y * jump_amplitude
		is_jumping = true
		

func _basis_from_normal(normal : Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)
	
	result = result.orthonormalized()
	result.x *= scale.x
	result.y *= scale.y
	result.z *= scale.z
	
	return result
