extends CanvasLayer
class_name HUD

## Public API surface for gameplay to push UI updates through. Objective
## system doesn't exist yet, so that one just updates the visuals; set_health
## and set_ammo are meant to be connected directly to a Health node's
## health_changed / a WeaponBase's ammo_changed signal respectively.

@onready var _health_bar: ProgressBar = %HealthBar
@onready var _ammo_label: Label = %AmmoLabel
@onready var _weapon_name_label: Label = %WeaponNameLabel
@onready var _objective_label: Label = %ObjectiveLabel
@onready var _lives_label: Label = %LivesLabel
@onready var _end_message_label: Label = %EndMessageLabel

func set_health(current: float, max_value: float) -> void:
	_health_bar.max_value = max_value
	_health_bar.value = current

func set_ammo(current: int, max_value: int) -> void:
	_ammo_label.text = "%d / %d" % [current, max_value]

func set_weapon_name(weapon_name: String) -> void:
	_weapon_name_label.text = weapon_name

func set_objective(text: String) -> void:
	_objective_label.text = text

func set_lives(count: int) -> void:
	_lives_label.text = "Lives: %d" % count

func show_end_message(text: String) -> void:
	_end_message_label.text = text
	_end_message_label.visible = true
