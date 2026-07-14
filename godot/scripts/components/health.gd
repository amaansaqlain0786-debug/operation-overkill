extends Node
class_name Health

## Generic health tracker usable by any entity. Owns current/max health and
## emits signals on change/death; it never decides what "dying" means for its
## owner — that's entirely up to whoever listens to `died`. hit_sound/
## death_sound are played here (rather than by Player/EnemyBase individually)
## since "something with Health got hurt/died" is true for either.

signal health_changed(current: float, max_value: float)
signal damaged(amount: float)
signal died

@export var max_health: float = 100.0
@export var hit_sound: AudioStream
@export var death_sound: AudioStream

var current_health: float

func _ready() -> void:
	current_health = max_health

func set_max_health(value: float, refill: bool = true) -> void:
	max_health = value
	if refill:
		current_health = max_health
	health_changed.emit(current_health, max_health)

func take_damage(amount: float) -> void:
	if current_health <= 0.0:
		return
	current_health = maxf(current_health - amount, 0.0)
	health_changed.emit(current_health, max_health)
	damaged.emit(amount)
	AudioManager.play_sfx(hit_sound)
	if current_health <= 0.0:
		AudioManager.play_sfx(death_sound)
		died.emit()

func heal(amount: float) -> void:
	current_health = minf(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func is_dead() -> bool:
	return current_health <= 0.0
