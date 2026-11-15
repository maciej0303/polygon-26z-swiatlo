class_name ProjectileHitHandler
extends Resource


@export var spawn_scene:PackedScene

func handle(data:Projectile.HitData) -> void:
	if spawn_scene:
		var inst:Node3D = spawn_scene.instantiate()
		(data.target as Node3D).add_sibling(inst)
		inst.global_position = data.projectile_pos
