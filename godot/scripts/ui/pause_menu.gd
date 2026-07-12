extends Control

## Overlay driven by GameManager's pause state. Runs even while the tree is
## paused (process_mode = ALWAYS on the scene root) so its own buttons stay
## responsive.

@onready var _resume_button: Button = %ResumeButton
@onready var _quit_button: Button = %QuitButton

func _ready() -> void:
	visible = false
	_resume_button.pressed.connect(_on_resume_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)
	GameManager.paused_changed.connect(_on_paused_changed)

func _on_resume_pressed() -> void:
	GameManager.set_paused(false)

func _on_quit_pressed() -> void:
	GameManager.set_paused(false)
	SceneManager.change_scene("res://scenes/ui/main_menu.tscn")

func _on_paused_changed(is_paused: bool) -> void:
	visible = is_paused
