extends Control

## Placeholder for the interactive mission-select world map described in the
## GDD. No regions/mission cards exist yet; this only proves navigation.

@onready var _back_button: Button = %BackButton

func _ready() -> void:
	_back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	SceneManager.change_scene("res://scenes/ui/main_menu.tscn")
