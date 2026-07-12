extends Node

## Entry point set as the project's main scene. Its only job is to hand off
## to SceneManager so every subsequent transition goes through one system.

func _ready() -> void:
	GameManager.change_state(GameManager.GameState.MAIN_MENU)
	SceneManager.change_scene("res://scenes/ui/main_menu.tscn", false)
