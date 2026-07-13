extends State

## Grounded, no horizontal input. Still applies friction/gravity every frame
## so the handoff into Run/Jump/Fall is seamless instead of a hard snap.

const RUN := &"Run"
const JUMP := &"Jump"
const FALL := &"Fall"

@onready var player: Player = owner as Player

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		transitioned.emit(FALL)
		return
	if player.has_buffered_jump() and player.has_coyote_jump():
		transitioned.emit(JUMP)
		return
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta)
	player.move_and_slide()
	if not is_zero_approx(player.get_move_input()):
		transitioned.emit(RUN)
