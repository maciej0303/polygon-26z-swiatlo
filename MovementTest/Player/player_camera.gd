class_name PlayerCamera
extends Camera3D


## moves right/left/up/down based on mouse movement, captures and hides mouse [br]
## ESC to make the mouse free

@export var mouse_sensitivity:float = 0.01
@export var lerp_speed:float = 1.0
@export_range(0.0, PI*0.5, 0.001) var camera_limit_x:float = PI * 0.5
@export_range(0.0, PI*0.5, 0.001) var camera_limit_y:float = PI * 0.5

var target_rotation := Vector2.ZERO
var current_rotation := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	current_rotation.x = lerp_angle(
			current_rotation.x,
			target_rotation.x,
			lerp_speed * delta
		)

	current_rotation.y = lerp_angle(
			current_rotation.y,
			target_rotation.y,
			lerp_speed * delta
		)

	rotation.y = -current_rotation.x
	rotation.x = -current_rotation.y
	
	if Input.is_action_just_pressed(&"ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion:Vector2 = event.screen_relative
		target_rotation.x += motion.x * mouse_sensitivity 
		target_rotation.y += motion.y * mouse_sensitivity 

		target_rotation.y = clamp(
			target_rotation.y,
			- camera_limit_y,
			camera_limit_y
		)
		target_rotation.x = clamp(
			target_rotation.x,
			- camera_limit_x,
			camera_limit_x
		)
