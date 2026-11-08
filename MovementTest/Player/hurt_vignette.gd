extends ColorRect

@export var base_collider: Area3D


var t:Tween
var curr:float = 0.0

const MAX:float = 0.05

func _ready() -> void:
	base_collider.area_entered.connect(_on_base_entered)
	set_instance_shader_parameter(&"size", 0.0)


func _on_base_entered(_who:Area3D) -> void:
	if t:  t.kill()
	t = create_tween().set_parallel(false)
	t.tween_method(set_vig_size, curr, MAX, 0.1)
	t.tween_method(set_vig_size, MAX, 0.0, 0.3).set_delay(0.05)


func set_vig_size(new:float) -> void:
	curr = new
	set_instance_shader_parameter(&"size", new)
	
