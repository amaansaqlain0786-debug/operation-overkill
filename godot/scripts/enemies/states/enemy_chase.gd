extends State

## Moves directly toward the player. Gives up and returns to Patrol once the
## player is farther away than enemy_data.lose_interest_range.

const PATROL := &"Patrol"

@onready var enemy: EnemyBase = owner as EnemyBase

func physics_update(_delta: float) -> void:
	var lose_interest_range: float = enemy.enemy_data.lose_interest_range if enemy.enemy_data else 500.0
	if enemy.distance_to_player() > lose_interest_range:
		transitioned.emit(PATROL)
		return

	enemy.move_horizontal(enemy.direction_to_player())
