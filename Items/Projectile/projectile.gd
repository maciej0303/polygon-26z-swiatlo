class_name Projectile
extends RigidBody3D

## giga simple projectile, signal after hit and thats it

signal hit(data:HitData)

@export var coll_area:Area3D



func _ready() -> void:
	coll_area.area_entered.connect(_on_hit)
	coll_area.body_entered.connect(_on_hit)


func _on_hit(what:Object) -> void:
	if what == self or what == coll_area:  return
	coll_area.area_entered.disconnect(_on_hit)
	coll_area.body_entered.disconnect(_on_hit)
	var data:HitData = HitData.new()
	data.projectile_pos = global_position
	data.target = what
	hit.emit(data)
	
	queue_free.call_deferred()


class HitData:
	extends RefCounted
	
	var target:Object
	var projectile_pos:Vector3
