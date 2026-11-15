class_name ProjectileSpawner
extends Node3D


@export var projectile_scene:PackedScene

@export var on_hit:ProjectileHitHandler

@export var projectile_parent:Node3D

@export var throw_strength:float = 15.0

func get_instance() -> Projectile:
	var inst:Projectile = projectile_scene.instantiate()
	add_child(inst)
	return inst


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"ui_accept"):
		throw(get_throw_direction() * throw_strength)

func throw(vec:Vector3, prj:Projectile=null) -> void:
	if not prj:
		prj = get_instance()
	if prj.is_inside_tree():
		prj.reparent(projectile_parent)
	else:
		projectile_parent.add_child(prj)
	prj.global_position = global_position
	prj.apply_central_impulse(vec * prj.mass)
	
	prj.hit.connect(on_hit.handle, CONNECT_ONE_SHOT)
	

func get_throw_direction() -> Vector3:
	var camera:Camera3D = get_viewport().get_camera_3d()
	var center:Vector2 = get_viewport().get_visible_rect().size / 2.0

	var direction:Vector3 = camera.project_ray_normal(center)
	direction += Vector3.UP * 0.25
	return direction.normalized()
