extends Node
class_name ObjectPool

## Generic pre-warmed pool for a single PackedScene. Intended for
## high-frequency instances (projectiles, casings, hit VFX) where
## instantiate()/queue_free() churn would hurt performance.

@export var scene: PackedScene
@export var prewarm_count: int = 16

var _available: Array[Node] = []

func _ready() -> void:
	for i in prewarm_count:
		_available.append(_create_instance())

func acquire() -> Node:
	var instance: Node = _available.pop_back() if not _available.is_empty() else _create_instance()
	instance.process_mode = Node.PROCESS_MODE_INHERIT
	if "visible" in instance:
		instance.visible = true
	return instance

func release(instance: Node) -> void:
	instance.process_mode = Node.PROCESS_MODE_DISABLED
	if "visible" in instance:
		instance.visible = false
	_available.append(instance)

func _create_instance() -> Node:
	var instance: Node = scene.instantiate()
	add_child(instance)
	instance.process_mode = Node.PROCESS_MODE_DISABLED
	if "visible" in instance:
		instance.visible = false
	return instance
