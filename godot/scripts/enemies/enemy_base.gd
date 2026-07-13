extends CharacterBody2D
class_name EnemyBase

## Shared skeleton and physics/detection primitives for all enemy types.
## Concrete enemies (Rifleman, etc.) inherit this scene and add their own
## StateMachine/State children on top; this script never implements any
## specific enemy's decision logic, only what its states call into.

@export var enemy_data: EnemyData

@onready var sprite: Sprite2D = $Sprite2D

var gravity: float = 980.0
var facing_direction: float = 1.0
var patrol_origin: Vector2

func _ready() -> void:
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity", 980.0)
	patrol_origin = global_position

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
	var players := get_tree().get_nodes_in_group("player")
	return players[0] as Player if not players.is_empty() else null

func distance_to_player() -> float:
	var player := get_player()
	return global_position.distance_to(player.global_position) if player else INF

func direction_to_player() -> float:
	var player := get_player()
	if player == null:
		return facing_direction
	return signf(player.global_position.x - global_position.x)
