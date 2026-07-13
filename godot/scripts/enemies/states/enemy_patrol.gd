extends State

## Walks back and forth within enemy_data.patrol_distance of the enemy's
## spawn point (EnemyBase.patrol_origin). Switches to Chase the instant the
## player enters enemy_data.detection_range.

const CHASE := &"Chase"

@onready var enemy: EnemyBase = owner as EnemyBase

var _direction: float = 1.0

func physics_update(_delta: float) -> void:
	var detection_range: float = enemy.enemy_data.detection_range if enemy.enemy_data else 400.0
	if enemy.distance_to_player() <= detection_range:
		transitioned.emit(CHASE)
		return

	var patrol_distance: float = enemy.enemy_data.patrol_distance if enemy.enemy_data else 64.0
	var offset := enemy.global_position.x - enemy.patrol_origin.x
	if offset >= patrol_distance:
		_direction = -1.0
	elif offset <= -patrol_distance:
		_direction = 1.0

	enemy.move_horizontal(_direction)
