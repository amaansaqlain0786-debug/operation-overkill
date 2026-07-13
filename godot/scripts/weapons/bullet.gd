extends Area2D
class_name Bullet

## Pooled projectile. launch() positions/aims/arms it and records the pool
## that owns it; it despawns back to that pool on hitting anything on its
## collision mask (World or Enemy) or after max_lifetime, whichever is first.

@export var speed: float = 800.0
@export var max_lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var damage: float = 10.0

var _pool: ObjectPool
var _elapsed: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func launch(from_position: Vector2, launch_direction: Vector2, bullet_damage: float, pool: ObjectPool) -> void:
	global_position = from_position
	direction = launch_direction.normalized()
	rotation = direction.angle()
	damage = bullet_damage
	_pool = pool
	_elapsed = 0.0

func _physics_process(delta: float) -> void:
	_elapsed += delta
	global_position += direction * speed * delta
	if _elapsed >= max_lifetime:
		_despawn()

func _on_body_entered(body: Node2D) -> void:
	if body is EnemyBase:
		body.queue_free()
	_despawn()

func _despawn() -> void:
	# May be called from _on_body_entered, itself a physics callback — toggling
	# a CollisionObject2D's disabled state (which release() does via
	# process_mode) is unsafe there, so defer the actual release.
	if _pool:
		_pool.release.call_deferred(self)
	else:
		queue_free()
