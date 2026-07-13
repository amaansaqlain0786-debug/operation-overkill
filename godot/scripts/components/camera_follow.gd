extends Camera2D
class_name CameraFollow

## Smoothed camera follow with horizontal lookahead and a vertical deadzone.
## Forces top_level on so the camera's world position is driven entirely by
## this script instead of rigidly inheriting the parent's transform — without
## that, the parent's instant motion would leak through underneath the
## smoothing every frame. CameraManager still owns screen shake via `offset`/
## `rotation`, which this script never touches, so the two compose cleanly.

@export var target_path: NodePath

@export_group("Follow")
@export var follow_speed: float = 8.0

@export_group("Lookahead")
@export var lookahead_distance: float = 48.0
@export var lookahead_speed: float = 4.0

@export_group("Vertical Deadzone")
@export var vertical_deadzone: float = 24.0

var _target: Node2D
var _last_target_position: Vector2
var _smoothed_position: Vector2
var _lookahead_offset: float = 0.0

func _ready() -> void:
	top_level = true
	_target = get_node(target_path) as Node2D if target_path != NodePath() else get_parent() as Node2D
	if _target == null:
		return
	_last_target_position = _target.global_position
	_smoothed_position = _target.global_position
	global_position = _smoothed_position

func _physics_process(delta: float) -> void:
	if _target == null:
		return

	var target_position := _target.global_position
	var target_velocity_x: float = _target.velocity.x if "velocity" in _target else \
		(target_position.x - _last_target_position.x) / delta
	_last_target_position = target_position

	var desired_lookahead := 0.0
	if not is_zero_approx(target_velocity_x):
		desired_lookahead = signf(target_velocity_x) * lookahead_distance
	_lookahead_offset = move_toward(_lookahead_offset, desired_lookahead, lookahead_speed * lookahead_distance * delta)

	var follow_target := Vector2(target_position.x + _lookahead_offset, _smoothed_position.y)
	var vertical_delta := target_position.y - _smoothed_position.y
	if absf(vertical_delta) > vertical_deadzone:
		follow_target.y = target_position.y - signf(vertical_delta) * vertical_deadzone

	_smoothed_position = _smoothed_position.lerp(follow_target, 1.0 - exp(-follow_speed * delta))
	global_position = _smoothed_position
