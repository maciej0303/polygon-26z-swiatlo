@tool
extends Node3D

@export_range(0.1, 60.0, 0.01) var lifetime:float = 10.0
@export var damage:float = 0.3

@export var radius:float = 1.0:
	set(new):
		radius = clampf(new, 0.5, 6.0)
		_update_radius()
@export var light:OmniLight3D:
	set(new):  light = new;  _update_radius()
@export var fire_particles:CPUParticles3D:
	set(new):  fire_particles = new;  _update_radius()
@export var impact_particles:CPUParticles3D:
	set(new):  impact_particles = new;  _update_radius()
@export var area_3d: Area3D
@export var collision_shape_3d: CollisionShape3D:
	set(new):  collision_shape_3d = new;  _update_radius()


func _ready() -> void:
	if Engine.is_editor_hint():  return
	impact_particles.emitting = true
	_tween_light(radius, 0.3)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	get_tree().create_timer(maxf(0.01, lifetime - fire_particles.lifetime)).timeout.connect(
		func() -> void:
			fire_particles.emitting = false
			_tween_light(0.0, fire_particles.lifetime * 0.5)
	)
	

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():  return
	for area:Area3D in area_3d.get_overlapping_areas():
		if area is Enemy:
			var dmg:DamageContext = DamageContext.new_fire(delta * damage)
			area.damage(dmg)


func _tween_light(to_radius:float, dur:float) -> void:
	var t:Tween = create_tween()
	t.tween_property(light, "omni_range", to_radius, dur)

func _update_radius() -> void:
	if light:
		light.omni_range = radius * 1.2 # light outside of particles
	if fire_particles:
		fire_particles.emission_ring_radius = radius - 1.0
		fire_particles.amount = maxi(8, ceili(4 * radius * radius))
	if impact_particles:
		impact_particles.emission_ring_radius = radius
		impact_particles.amount = maxi(8, ceili(4 * radius * radius))
	if collision_shape_3d:
		var shp:CylinderShape3D = CylinderShape3D.new()
		shp.radius = radius
		shp.height = 0.2
		collision_shape_3d.shape = shp
