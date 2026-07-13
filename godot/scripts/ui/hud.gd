extends CanvasLayer
class_name HUD

## Public API surface for gameplay to push UI updates through. Ammo/objective
## systems don't exist yet, so those two just update the visuals; set_health
## is meant to be connected directly to a Health node's health_changed signal.

@onready var _health_bar: ProgressBar = %HealthBar
@onready var _ammo_label: Label = %AmmoLabel
@onready var _objective_label: Label = %ObjectiveLabel

func set_health(current: float, max_value: float) -> void:
	_health_bar.max_value = max_value
	_health_bar.value = current

func set_ammo(current: int, reserve: int) -> void:
	_ammo_label.text = "%d / %d" % [current, reserve]

func set_objective(text: String) -> void:
	_objective_label.text = text
