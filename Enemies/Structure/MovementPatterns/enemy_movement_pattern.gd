class_name EnemyMovementPattern
extends Resource


@export var speed: float = 1.0

@export var xz_plane: Curve
@export var yz_plane: Curve
@export var speed_curve: Curve


func get_position(start: Vector3, end: Vector3, time: float) -> Vector3:
	var progress: float = clampf(time * speed, 0.0, 1.0)

	var direction: Vector3 = end - start
	var right: Vector3 = Vector3.UP.cross(direction.normalized()).normalized()

	var position: Vector3 = start.lerp(end, progress)
	position += right * xz_plane.sample_baked(progress)
	position += Vector3.UP * yz_plane.sample_baked(progress)

	return position
