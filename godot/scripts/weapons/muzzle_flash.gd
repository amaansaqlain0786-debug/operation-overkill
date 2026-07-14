extends Sprite2D
class_name MuzzleFlash

## Self-destructing one-shot visual; instanced fresh per shot rather than
## pooled since fire rates here are low-frequency enough not to warrant it.

@export var lifetime: float = 0.05

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
