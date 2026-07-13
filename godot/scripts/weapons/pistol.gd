extends WeaponBase
class_name Pistol

## Fires along the wielder's facing direction with a fire_rate cooldown read
## from weapon_data. Bullets are drawn from the BulletPool child (a generic
## ObjectPool) instead of being instantiated/freed directly.

@onready var _bullet_pool: ObjectPool = $BulletPool

var _cooldown_remaining: float = 0.0

func _physics_process(delta: float) -> void:
	_cooldown_remaining = maxf(_cooldown_remaining - delta, 0.0)

func fire() -> void:
	if _cooldown_remaining > 0.0:
		return
	var fire_rate: float = weapon_data.fire_rate if weapon_data else 0.25
	var damage: float = weapon_data.damage if weapon_data else 10.0
	_cooldown_remaining = fire_rate

	var player := owner as Player
	var facing: float = player.facing_direction if player else 1.0

	var bullet: Bullet = _bullet_pool.acquire()
	bullet.launch(muzzle_point.global_position, Vector2(facing, 0.0), damage, _bullet_pool)
