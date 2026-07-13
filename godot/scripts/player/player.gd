extends CharacterBody2D
class_name Player

## Movement is driven by the State children under StateMachine; this script
## only owns shared physics math, input polling and the coyote time / jump
## buffer timers so no individual state has to duplicate that logic.

@export var operative_data: OperativeData
@export var debug_movement: bool = false

@export_group("Movement")
@export var default_move_speed: float = 300.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0
@export var air_control_multiplier: float = 0.65

@export_group("Jump")
@export var jump_velocity: float = -400.0
@export var gravity_multiplier: float = 1.0
@export var max_fall_speed: float = 900.0
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@onready var camera: Camera2D = $Camera2D
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var equipped_weapon: WeaponBase = $Pistol

var move_speed: float = 300.0
var gravity: float = 980.0
var facing_direction: float = 1.0

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0

func _ready() -> void:
	add_to_group("player")
	CameraManager.register_camera(camera)
	move_speed = operative_data.move_speed if operative_data else default_move_speed
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity", 980.0) * gravity_multiplier
	if debug_movement:
		print("[Player] ready. move_speed=%s gravity=%s state_machine.current_state=%s" % [
			move_speed, gravity, state_machine.current_state,
		])

func _physics_process(delta: float) -> void:
	_coyote_timer = coyote_time if is_on_floor() else maxf(_coyote_timer - delta, 0.0)
	_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)
	if Input.is_action_pressed("fire") and equipped_weapon:
		equipped_weapon.fire()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time

func get_move_input() -> float:
	return Input.get_axis("move_left", "move_right")

func has_buffered_jump() -> bool:
	return _jump_buffer_timer > 0.0

func has_coyote_jump() -> bool:
	return _coyote_timer > 0.0

func consume_jump() -> void:
	_jump_buffer_timer = 0.0
	_coyote_timer = 0.0

func apply_gravity(delta: float) -> void:
	velocity.y = minf(velocity.y + gravity * delta, max_fall_speed)

func apply_horizontal_movement(delta: float, control_multiplier: float = 1.0) -> void:
	var direction := get_move_input()
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * move_speed, acceleration * control_multiplier * delta)
		set_facing(direction)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * control_multiplier * delta)

func set_facing(direction: float) -> void:
	facing_direction = signf(direction)
	sprite.flip_h = facing_direction < 0.0
	if equipped_weapon:
		equipped_weapon.scale.x = facing_direction
