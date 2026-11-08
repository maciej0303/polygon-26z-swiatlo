class_name EnemyMesh
extends MeshInstance3D


@export var merge_distance: float = 0.05

@export var tex:Texture2D

const POINT_COUNT:int = 64
var idx:int = -1

var points: Array[Vector4] = []

var image:Image

#func _ready() -> void:
	#points.resize(POINT_COUNT)
	#image = tex.get_image()
	#if image.is_compressed():
		#image.decompress()


func update_burn(val:float) -> void:
	set_instance_shader_parameter(&"progress", val)


func update_destroy(val:float) -> void:
	set_instance_shader_parameter(&"destroy_progress", val)


#func check_radius(hit_pos:Vector3, rad:float) -> bool:
	#hit_pos = to_local(hit_pos)
	#var uv: Vector2 = Vector2(hit_pos.x, -hit_pos.y) / mesh.size
	#uv += Vector2(0.5, 0.5)
	#if uv.x - rad > 1.0 or uv.x +rad < 0.0:
		#return false
	#if uv.y - rad > 1.0 or uv.y +rad < 0.0:
		#return false
	#return true
#
#
#func animate_burn(hit_pos:Vector3, strength:float, radius:float) -> void:
	#hit_pos = to_local(hit_pos)
	#var uv: Vector2 = Vector2(hit_pos.x, -hit_pos.y) / mesh.size
	#uv += Vector2(0.5, 0.5)
#
	#strength *= exp(-absf(to_local(hit_pos).z) * 0.1)
	#
	#var should_add: bool = true
#
	#for i: int in range(idx + 1):
		#var existing: Vector2 = Vector2(points[i].x, points[i].y)
		#var dist: float = existing.distance_to(uv)
#
		#if dist < points[i].z:
			#var influence: float = 1.0 - dist / points[i].z
			#points[i].w = minf(points[i].w + strength * influence, 1.0)
#
		#if dist < merge_distance:
			#should_add = false
#
	#if should_add and idx < POINT_COUNT-1:
		#idx += 1
		#points[idx] = (Vector4(uv.x, uv.y, radius, strength))
#
	#update_shader()
#
#
#func update_shader() -> void:
	#var material: ShaderMaterial = get_active_material(0) as ShaderMaterial
#
	#if material:
		#material.set_shader_parameter("points", PackedVector4Array(points))
		#material.set_shader_parameter("point_count", points.size())
#
#
#func get_coverage(samples:int = 100) -> float:
	#var covered:float = 0.0
	#var valid:int = 0
#
	#for i:int in range(samples):
		#var uv:Vector2 = Vector2(randf(), randf())
		#var pixel:Color= image.get_pixel(
			#int(uv.x * image.get_width()),
			#int(uv.y * image.get_height())
		#)
#
		#if pixel.a < 0.5:
			#continue
#
		#valid += 1
		#
		#var c:float = 0.0
		#for _j:int in range(int(idx * 0.1)):
			#var p:Vector4= points[randi_range(0, idx)]
			#var center:Vector2 = Vector2(p.x, p.y)
			#var s:float = uv.distance_to(center) * p.w
			#c = maxf(c, s)
			#if c > 0.9:
				#break
		#covered += c
#
	#if valid == 0:
		#return 0.0
#
	#return float(covered) / valid
