class_name Enemy
extends Area3D

@export var mesh:EnemyMesh

@export var movement_pattern:EnemyMovementPattern

var damage_taken:float= 0.0

var start_pos:Vector3
var target_pos:Vector3
var direction_to_target:Vector3
var total_length:float

const LINE_ACCEL:EnemyMovementPattern = preload("uid://dmym4gqkxgep2")
const LINE:EnemyMovementPattern = preload("uid://chx4833p8yrs3")

const ZIGZAG:EnemyMovementPattern = preload("uid://gbdpfb5emevn")
const JUMPER:EnemyMovementPattern = preload("uid://deltj7jkgtbu6")

var time:float = 0.0

func _ready() -> void:
	# TODO proper handling of touching player base
	area_entered.connect(func(_a:Area3D) -> void:  queue_free(), CONNECT_ONE_SHOT)
	
	await get_tree().process_frame
	start_pos = global_position
	var targ:Path3D = get_tree().get_first_node_in_group(&"EnemyTarget")
	target_pos = targ.curve.get_closest_point(targ.to_local(global_position))
	target_pos += targ.global_position
	total_length = global_position.distance_to(target_pos)
	
	movement_pattern = [ZIGZAG, JUMPER, LINE, LINE_ACCEL].pick_random()
	#movement_pattern = JUMPER


func _process(delta: float) -> void:
	global_position = movement_pattern.get_position(
		start_pos, target_pos, time
	)
	time += delta


func damage(ctx:DamageContext) -> void:
	if damage_taken >= 1.0:  return
	damage_taken += ctx.strength
	damage_taken = clampf(damage_taken, 0.0, 1.0)
	
	mesh.update_burn(remap(damage_taken, 0.0, 1.0, 0.0, 0.4)) # imo dla 0.4 starczy, nie musi do 1.0 isc
	
	if damage_taken >= 1.0:
		# smierc
		var t:Tween = create_tween().set_parallel()
		t.tween_method(mesh.update_destroy, 0.0, 1.0, 0.4)
		t.finished.connect(queue_free)
