class_name DamageContext
extends RefCounted

enum Type 
{
	LIGHT = 0,
	FIRE = 1,
}
var type:Type = Type.LIGHT
var strength:float 
#var radius:float
#var point:Vector3
#var normal:Vector3


static func new_fire(dmg:float) -> DamageContext:
	var ctx:DamageContext = DamageContext.new(dmg)
	ctx.type = Type.FIRE
	return ctx


static func new_light(dmg:float) -> DamageContext:
	var ctx:DamageContext = DamageContext.new(dmg)
	ctx.type = Type.LIGHT
	return ctx
	

func _init(dmg:float=1.0) -> void:
	strength = dmg
