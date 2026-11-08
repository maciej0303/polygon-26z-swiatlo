extends PathFollow3D


@export var speed:float = 0.3


func _process(delta: float) -> void:
	var dir:float = 0.0
	if Input.is_key_pressed(KEY_A):
		dir += -1.0
	if Input.is_key_pressed(KEY_D):
		dir += 1.0
	
	progress_ratio -= dir * delta * speed
	progress_ratio = clampf(progress_ratio, 0.001, 0.9999)
