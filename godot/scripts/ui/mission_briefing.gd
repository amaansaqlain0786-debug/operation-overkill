extends Control

## Placeholder for the pre-mission briefing screen. No mission data binding
## yet; this only proves navigation into and out of a level.

@onready var _start_button: Button = %StartButton
@onready var _back_button: Button = %BackButton

func _ready() -> void:
	_start_button.pressed.connect(_on_start_pressed)
	_back_button.pressed.connect(_on_back_pressed)

func _on_start_pressed() -> void:
	GameManager.change_state(GameManager.GameState.IN_MISSION)
	SceneManager.change_scene("res://scenes/levels/level_base.tscn")

func _on_back_pressed() -> void:
	SceneManager.change_scene("res://scenes/ui/world_map.tscn")
