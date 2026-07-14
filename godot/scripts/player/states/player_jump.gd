extends State

## Rising phase. Consumes the jump buffer/coyote window on enter, then hands
## off to Fall the instant vertical velocity turns non-negative.

const FALL := &"Fall"

@export var jump_sound: AudioStream

@onready var player: Player = owner as Player

func enter(_previous_state: StringName) -> void:
	player.velocity.y = player.jump_velocity
	player.consume_jump()
	AudioManager.play_sfx(jump_sound)

func physics_update(delta: float) -> void:
	player.apply_horizontal_movement(delta, player.air_control_multiplier)
	player.apply_gravity(delta)
	player.move_and_slide()
	if player.velocity.y >= 0.0:
		transitioned.emit(FALL)
