extends CharacterBody2D
class_name EnemyBase

## Shared skeleton and physics/detection primitives for all enemy types.
## Concrete enemies (Rifleman, etc.) inherit this scene and add their own
## StateMachine/State children on top; this script never implements any
## specific enemy's decision logic, only what its states call into.

@export var enemy_data: EnemyData
@export var hit_flash_duration: float = 0.1

@onready var sprite: Sprite2D = $Sprite2D
@onready var health: Health = $Health
@onready var contact_damage: ContactDamage = $ContactDamage

var gravity: float = 980.0
var facing_direction: float = 1.0
var patrol_origin: Vector2

func _ready() -> void:
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity", 980.0)
	patrol_origin = global_position
	health.set_max_health(enemy_data.max_health if enemy_data else 50.0)
	health.died.connect(_on_died)
	health.damaged.connect(_on_damaged)
	contact_damage.damage = enemy_data.damage if enemy_data else 10.0

func _on_died() -> void:
	queue_free()

func _on_damaged(_amount: float) -> void:
	sprite.modulate = Color(3.0, 3.0, 3.0, 1.0)
	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), hit_flash_duration)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func move_horizontal(direction: float) -> void:
	var speed: float = enemy_data.move_speed if enemy_data else 100.0
	velocity.x = direction * speed
	if not is_zero_approx(direction):
		set_facing(direction)
	move_and_slide()

func set_facing(direction: float) -> void:
	facing_direction = signf(direction)
	sprite.flip_h = facing_direction < 0.0

func get_player() -> Player:
	# On respawn, the dying player can still be in the group for one frame
	# (queue_free defers removal) alongside the freshly spawned one — skip
	# anything already queued for deletion so enemies latch onto the new one.
	for candidate in get_tree().get_nodes_in_group("player"):
		if not candidate.is_queued_for_deletion():
			return candidate as Player
	return null

func distance_to_player() -> float:
	var player := get_player()
	return global_position.distance_to(player.global_position) if player else INF

func direction_to_player() -> float:
	var player := get_player()
	if player == null:
		return facing_direction
	return signf(player.global_position.x - global_position.x)
