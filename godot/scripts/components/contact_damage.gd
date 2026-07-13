extends Area2D
class_name ContactDamage

## Deals damage to anything with a Health child node that enters and stays
## in this area, once immediately on contact and then again every
## tick_interval while still overlapping. Entirely independent of what's
## dealing or receiving the damage — attach to enemies, hazards, etc.

@export var damage: float = 10.0
@export var tick_interval: float = 1.0

var _cooldowns: Dictionary = {}

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	for body in _cooldowns.keys():
		_cooldowns[body] -= delta
		if _cooldowns[body] <= 0.0:
			_cooldowns[body] = tick_interval
			_deal_damage(body)

func _on_body_entered(body: Node2D) -> void:
	if _get_health(body):
		_cooldowns[body] = 0.0

func _on_body_exited(body: Node2D) -> void:
	_cooldowns.erase(body)

func _deal_damage(body: Node2D) -> void:
	var health := _get_health(body)
	if health:
		health.take_damage(damage)

func _get_health(body: Node2D) -> Health:
	if body.has_node("Health"):
		return body.get_node("Health") as Health
	return null
