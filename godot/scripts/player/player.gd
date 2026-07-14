extends CharacterBody2D
class_name Player

## Movement is driven by the State children under StateMachine; this script
## only owns shared physics math, input polling and the coyote time / jump
## buffer timers so no individual state has to duplicate that logic.

@export var operative_data: OperativeData
@export var default_max_health: float = 100.0
@export var damage_shake_amount: float = 0.25
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

@export_group("Recoil")
## How fast the recoil kick itself decays (px/s^2) — deliberately separate
## from acceleration/friction. Reusing the movement system's own correction
## rate made the kick numerically correct but visually invisible: it decayed
## in ~3 frames (~2.5px of total displacement). This gives it its own,
## slower decay so it actually reads as a kick.
@export var recoil_decay_speed: float = 400.0

@onready var camera: Camera2D = $Camera2D
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var equipped_weapon: WeaponBase = $Pistol
@onready var health: Health = $Health

var move_speed: float = 300.0
var gravity: float = 980.0
var facing_direction: float = 1.0

var recoil_velocity_x: float = 0.0

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _base_velocity_x: float = 0.0

func _ready() -> void:
	add_to_group("player")
	CameraManager.register_camera(camera)
	move_speed = operative_data.move_speed if operative_data else default_move_speed
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity", 980.0) * gravity_multiplier
	health.set_max_health(operative_data.max_health if operative_data else default_max_health)
	health.died.connect(_on_died)
	health.damaged.connect(_on_damaged)
	if debug_movement:
		print("[Player] ready. move_speed=%s gravity=%s state_machine.current_state=%s" % [
			move_speed, gravity, state_machine.current_state,
		])

func _on_died() -> void:
	CameraManager.register_camera(null)
	queue_free()

func _on_damaged(_amount: float) -> void:
	CameraManager.shake(damage_shake_amount)

func _physics_process(delta: float) -> void:
	_coyote_timer = coyote_time if is_on_floor() else maxf(_coyote_timer - delta, 0.0)
	_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)
	recoil_velocity_x = move_toward(recoil_velocity_x, 0.0, recoil_decay_speed * delta)
	if Input.is_action_pressed("fire") and equipped_weapon:
		equipped_weapon.fire()
	if Input.is_action_just_pressed("reload") and equipped_weapon:
		equipped_weapon.reload()

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

func apply_recoil(amount: float) -> void:
	recoil_velocity_x += amount
	if debug_movement:
		# velocity.x itself isn't recomposed until apply_horizontal_movement
		# runs later this same frame (StateMachine is a child of Player, so
		# it processes after this) — this shows recoil_velocity_x landing;
		# the second print below shows the actual velocity.x it produces.
		print("[Player] apply_recoil(%.1f) -> recoil_velocity_x=%.1f" % [amount, recoil_velocity_x])

func apply_horizontal_movement(delta: float, control_multiplier: float = 1.0) -> void:
	var direction := get_move_input()
	if direction != 0.0:
		_base_velocity_x = move_toward(_base_velocity_x, direction * move_speed, acceleration * control_multiplier * delta)
		set_facing(direction)
	else:
		_base_velocity_x = move_toward(_base_velocity_x, 0.0, friction * control_multiplier * delta)
	velocity.x = _base_velocity_x + recoil_velocity_x
	if debug_movement and not is_zero_approx(recoil_velocity_x):
		print("[Player] velocity.x now=%.1f (base=%.1f recoil=%.1f)" % [velocity.x, _base_velocity_x, recoil_velocity_x])

func set_facing(direction: float) -> void:
	facing_direction = signf(direction)
	sprite.flip_h = facing_direction < 0.0
	if equipped_weapon:
		equipped_weapon.scale.x = facing_direction
