extends Node3D

func _basis_from_normal(local_transform : Transform3D, normal : Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(local_transform.basis.z)
	result.y = normal
	result.z = local_transform.basis.x.cross(normal)
	
	result = result.orthonormalized()
	result.x *= scale.x
	result.y *= scale.y
	result.z *= scale.z
	
	return result
