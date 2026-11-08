@tool
extends MultiMeshInstance3D

@export var density_texture: Texture2D
@export var area_size: Vector2 = Vector2(100.0, 100.0)
@export var max_attempts: int = 100_000

@export var face_node:Node3D
@export var rotation_amount:float = 0.5:
	set(new):
		rotation_amount = new
		#generate_instances()

@export var scale_min:float = 1.0
@export var scale_max:float = 1.0

@export var gen_seed:int = 1

@export var generate: bool = false:
	set(value):
		if value:
			generate_instances()
		generate = false


func generate_instances() -> void:
	if multimesh == null:
		push_error("MultiMesh is not assigned.")
		return

	if density_texture == null:
		push_error("Density texture is not assigned.")
		return

	var image: Image = density_texture.get_image()

	if image == null:
		push_error("Could not retrieve texture image.")
		return

	var target_count: int = multimesh.instance_count
	var spawned_count: int = 0
	var attempts: int = 0

	multimesh.visible_instance_count = 0

	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = hash(gen_seed)
	
	var rot_center:Vector2 = Vector2(face_node.global_position.x, face_node.global_position.z)
	rot_center -= Vector2(global_position.x, global_position.z)
	
	while spawned_count < target_count and attempts < max_attempts:
		attempts += 1

		var random_x: float = rng.randf_range(-area_size.x * 0.5, area_size.x * 0.5)
		var random_z: float = rng.randf_range(-area_size.y * 0.5, area_size.y * 0.5)

		var uv: Vector2 = Vector2(
			(random_x / area_size.x) + 0.5,
			(random_z / area_size.y) + 0.5
		)

		var pixel_x: int = clampi(
			int(uv.x * float(image.get_width())),
			0,
			image.get_width() - 1
		)

		var pixel_y: int = clampi(
			int(uv.y * float(image.get_height())),
			0,
			image.get_height() - 1
		)

		var color: Color = image.get_pixel(pixel_x, pixel_y)
		var grayscale: float = color.get_luminance()

		if rng.randf() > grayscale:
			continue
	
		var instance_transform: Transform3D = Transform3D.IDENTITY

		var s: float = 1.0 + rng.randf_range(scale_min, scale_max)
		instance_transform = instance_transform.scaled_local(Vector3.ONE * s)
		instance_transform.origin = Vector3(random_x, (s - 1.0), random_z)
		
		var to_face:Vector2 = rot_center - Vector2(random_x, random_z)
		var ang:float = atan2(to_face.x, to_face.y)
		ang *= rotation_amount
		instance_transform = instance_transform.rotated_local(Vector3.UP, ang)

		multimesh.set_instance_transform(spawned_count, instance_transform)
		spawned_count += 1

	multimesh.visible_instance_count = spawned_count

	print(
		"Generated ", spawned_count,
		"/", target_count,
		" instances in ", attempts,
		" attempts."
	)
