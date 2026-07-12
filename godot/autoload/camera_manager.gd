extends Node

## Trauma-based screen shake and a registry for the currently active Camera2D.
## Gameplay scenes call register_camera() on ready; combat/juice systems added
## later call shake() — no camera follow/targeting logic lives here yet.

const MAX_OFFSET := Vector2(24.0, 16.0)
const MAX_ROLL := 0.1
const TRAUMA_DECAY := 1.5

var active_camera: Camera2D

var _trauma: float = 0.0

func register_camera(camera: Camera2D) -> void:
	active_camera = camera

func shake(amount: float) -> void:
	_trauma = clampf(_trauma + amount, 0.0, 1.0)

func _process(delta: float) -> void:
	if active_camera == null:
		return
	if _trauma > 0.0:
		_trauma = maxf(_trauma - TRAUMA_DECAY * delta, 0.0)
		var power := _trauma * _trauma
		active_camera.offset = Vector2(
			MAX_OFFSET.x * power * (randf() * 2.0 - 1.0),
			MAX_OFFSET.y * power * (randf() * 2.0 - 1.0)
		)
		active_camera.rotation = MAX_ROLL * power * (randf() * 2.0 - 1.0)
	else:
		active_camera.offset = Vector2.ZERO
		active_camera.rotation = 0.0
