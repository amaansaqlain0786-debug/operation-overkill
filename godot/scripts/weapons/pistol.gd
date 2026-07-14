extends WeaponBase
class_name Pistol

## Fires along the wielder's facing direction with a fire_rate cooldown read
## from weapon_data. Bullets are drawn from the BulletPool child (a generic
## ObjectPool) instead of being instantiated/freed directly. Magazine-only —
## no reserve ammo pool depletion yet; reload always tops back up to
## magazine_size after weapon_data.reload_time and blocks firing meanwhile.

@export var default_magazine_size: int = 12
@export var default_reload_time: float = 1.0

@onready var _bullet_pool: ObjectPool = $BulletPool

var _cooldown_remaining: float = 0.0
var _is_reloading: bool = false
var _reload_time_remaining: float = 0.0

func _ready() -> void:
	magazine_size = weapon_data.magazine_size if weapon_data else default_magazine_size
	current_ammo = magazine_size

func _physics_process(delta: float) -> void:
	_cooldown_remaining = maxf(_cooldown_remaining - delta, 0.0)
	if _is_reloading:
		_reload_time_remaining -= delta
		if _reload_time_remaining <= 0.0:
			_is_reloading = false
			current_ammo = magazine_size
			ammo_changed.emit(current_ammo, magazine_size)

func reload() -> void:
	if _is_reloading or current_ammo >= magazine_size:
		return
	_is_reloading = true
	_reload_time_remaining = weapon_data.reload_time if weapon_data else default_reload_time

func fire() -> void:
	if _is_reloading or _cooldown_remaining > 0.0 or current_ammo <= 0:
		return
	var fire_rate: float = weapon_data.fire_rate if weapon_data else 0.25
	var damage: float = weapon_data.damage if weapon_data else 10.0
	_cooldown_remaining = fire_rate
	current_ammo -= 1
	ammo_changed.emit(current_ammo, magazine_size)

	var player := owner as Player
	var facing: float = player.facing_direction if player else 1.0

	_spawn_muzzle_flash()
	AudioManager.play_sfx(weapon_data.fire_sound if weapon_data else null)
	CameraManager.shake(fire_shake_amount)
	if player:
		# Physical kick opposite the shot direction. Goes through
		# apply_recoil() (its own decay, separate from movement
		# acceleration/friction) rather than touching velocity.x directly —
		# reusing the movement system's correction rate decayed the kick in
		# ~3 frames, which is numerically fine but visually invisible.
		player.apply_recoil(-facing * recoil_speed)

	var bullet: Bullet = _bullet_pool.acquire()
	bullet.launch(muzzle_point.global_position, Vector2(facing, 0.0), damage, _bullet_pool)

func _spawn_muzzle_flash() -> void:
	if weapon_data == null or weapon_data.muzzle_flash_scene == null:
		return
	var flash: Node2D = weapon_data.muzzle_flash_scene.instantiate()
	muzzle_point.add_child(flash)
