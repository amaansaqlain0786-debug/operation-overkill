extends Node2D
class_name LevelBase

## Structural template every mission/level scene inherits from. Spawns the
## player at PlayerSpawn, clamps the spawned camera to the level bounds, and
## owns the mission-level win/lose flow (lives, extraction, game over).

@export var player_scene: PackedScene = preload("res://scenes/player/player.tscn")

@export_group("Camera Bounds")
@export var camera_limit_left: int = -200
@export var camera_limit_top: int = -150
@export var camera_limit_right: int = 550
@export var camera_limit_bottom: int = 300

@export_group("Respawn")
@export var respawn_delay: float = 0.0

@export_group("Lives")
@export var max_lives: int = 3

@export_group("End Screen")
@export var end_message_duration: float = 3.0

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemies: Node2D = $Enemies
@onready var pickups: Node2D = $Pickups
@onready var destructibles: Node2D = $Destructibles
@onready var triggers: Node2D = $Triggers
@onready var hud: HUD = $HUD
@onready var extraction_zone: ExtractionZone = $Triggers/ExtractionZone

var current_lives: int
var _mission_ended: bool = false

func _ready() -> void:
	current_lives = max_lives
	hud.set_lives(current_lives)
	extraction_zone.player_entered.connect(_on_extraction_reached)
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

	var weapon := player_instance.equipped_weapon
	if weapon:
		weapon.ammo_changed.connect(hud.set_ammo)
		hud.set_ammo(weapon.current_ammo, weapon.magazine_size)
		hud.set_weapon_name(weapon.weapon_data.weapon_name if weapon.weapon_data else "")

func _on_player_died() -> void:
	if _mission_ended:
		return
	current_lives -= 1
	hud.set_lives(current_lives)
	if current_lives > 0:
		if respawn_delay > 0.0:
			await get_tree().create_timer(respawn_delay).timeout
		_spawn_player()
	else:
		_mission_ended = true
		GameManager.change_state(GameManager.GameState.GAME_OVER)
		_show_end_screen("GAME OVER")

func _on_extraction_reached() -> void:
	if _mission_ended:
		return
	_mission_ended = true
	GameManager.change_state(GameManager.GameState.EXTRACTION)
	_show_end_screen("MISSION COMPLETE")

func _show_end_screen(text: String) -> void:
	hud.show_end_message(text)
	await get_tree().create_timer(end_message_duration).timeout
	SceneManager.change_scene("res://scenes/ui/main_menu.tscn")

func _apply_camera_bounds(camera: Camera2D) -> void:
	camera.limit_left = camera_limit_left
	camera.limit_top = camera_limit_top
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom
