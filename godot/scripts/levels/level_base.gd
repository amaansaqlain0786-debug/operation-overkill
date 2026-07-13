extends Node2D
class_name LevelBase

## Structural template every mission/level scene inherits from. Spawns the
## player at PlayerSpawn and clamps the spawned camera to the level bounds;
## enemies/pickups/destructibles/triggers are containers for later systems.

@export var player_scene: PackedScene = preload("res://scenes/player/player.tscn")

@export_group("Camera Bounds")
@export var camera_limit_left: int = -200
@export var camera_limit_top: int = -150
@export var camera_limit_right: int = 550
@export var camera_limit_bottom: int = 300

@export_group("Respawn")
@export var respawn_delay: float = 0.0

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemies: Node2D = $Enemies
@onready var pickups: Node2D = $Pickups
@onready var destructibles: Node2D = $Destructibles
@onready var triggers: Node2D = $Triggers
@onready var hud: HUD = $HUD

func _ready() -> void:
	_spawn_player()

func _spawn_player() -> void:
	if player_scene == null:
		return
	var player_instance: Player = player_scene.instantiate()
	player_instance.position = player_spawn.position
	add_child(player_instance)
	_apply_camera_bounds(player_instance.camera)
	_setup_hud(player_instance)
	player_instance.health.died.connect(_on_player_died)

func _setup_hud(player_instance: Player) -> void:
	player_instance.health.health_changed.connect(hud.set_health)
	hud.set_health(player_instance.health.current_health, player_instance.health.max_health)

func _on_player_died() -> void:
	if respawn_delay > 0.0:
		await get_tree().create_timer(respawn_delay).timeout
	_spawn_player()

func _apply_camera_bounds(camera: Camera2D) -> void:
	camera.limit_left = camera_limit_left
	camera.limit_top = camera_limit_top
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom
