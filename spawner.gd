class_name Spawner
extends Node3D

@export var scene:PackedScene

@export var spawn_path:Path3D

@export var timer:Timer


func _ready() -> void:
	timer.timeout.connect(spawn)


func spawn() -> void:
	print("spawned")
	var sample:float = spawn_path.curve.get_baked_length() * randf()
	var pos:Vector3 = spawn_path.curve.sample_baked(sample) + global_position
	var inst:Node3D = scene.instantiate()
	add_child(inst)
	inst.global_position = pos
