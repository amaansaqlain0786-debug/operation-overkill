extends State

## Airborne and descending, including walking off a ledge without jumping.
## Still honors coyote time + a buffered jump press, matching Idle/Run.

const IDLE := &"Idle"
const RUN := &"Run"
const JUMP := &"Jump"

@onready var player: Player = owner as Player

func physics_update(delta: float) -> void:
	if player.has_buffered_jump() and player.has_coyote_jump():
		transitioned.emit(JUMP)
		return
	player.apply_horizontal_movement(delta, player.air_control_multiplier)
	player.apply_gravity(delta)
	player.move_and_slide()
	if player.is_on_floor():
		if is_zero_approx(player.get_move_input()):
			transitioned.emit(IDLE)
		else:
			transitioned.emit(RUN)
