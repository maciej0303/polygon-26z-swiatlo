extends SpotLight3D


@export var shape_cast_3d: ShapeCast3D


## 1 dmg means holding light on enemy for around 1s
@export var damage:float = 1.0

@export var dmg_range:float = 30.0
@export_exp_easing("attenuation") var distance_strength_fade:float
@export var piercing:int = 9
@export var piercing_dmg_loss:float = 0.8

var radius:float = 1.0

func _ready() -> void:
	if shape_cast_3d.shape is SphereShape3D:
		radius = shape_cast_3d.shape.radius


func _physics_process(delta: float) -> void:
	var curr_strength:float = damage
	
	for i:int in range(piercing): 
		if not shape_cast_3d.is_colliding():  break
		var c:Object = shape_cast_3d.get_collider(0)
		if c is Enemy:
			var dmg:DamageContext = DamageContext.new()
			dmg.radius = radius
			dmg.point = shape_cast_3d.get_collision_point(0)
			dmg.normal = shape_cast_3d.get_collision_normal(0)
			
			var dist:float = 1.0 - global_position.distance_to(dmg.point) / dmg_range
			dmg.strength = curr_strength * delta * ease(dist, distance_strength_fade)
			#print(ease(dist, distance_strength_fade))
			c.damage(dmg)
			
			curr_strength *= piercing_dmg_loss

		if c is CollisionObject3D:
			shape_cast_3d.add_exception(c)
			shape_cast_3d.remove_exception.call_deferred(c)
			shape_cast_3d.force_shapecast_update()
