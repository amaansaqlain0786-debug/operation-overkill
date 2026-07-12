extends Control

## Wires main menu buttons to scene navigation. Screens that don't exist yet
## (Armory, Operatives, Challenges, Settings, Credits) are stubbed with a
## print so the menu is fully clickable without pretending they're built.

@onready var _campaign_button: Button = %CampaignButton
@onready var _continue_button: Button = %ContinueButton
@onready var _armory_button: Button = %ArmoryButton
@onready var _operatives_button: Button = %OperativesButton
@onready var _challenges_button: Button = %ChallengesButton
@onready var _settings_button: Button = %SettingsButton
@onready var _credits_button: Button = %CreditsButton
@onready var _exit_button: Button = %ExitButton

func _ready() -> void:
	_campaign_button.pressed.connect(_on_campaign_pressed)
	_continue_button.pressed.connect(_on_continue_pressed)
	_armory_button.pressed.connect(func() -> void: print("Armory not implemented yet"))
	_operatives_button.pressed.connect(func() -> void: print("Operatives not implemented yet"))
	_challenges_button.pressed.connect(func() -> void: print("Challenges not implemented yet"))
	_settings_button.pressed.connect(func() -> void: print("Settings not implemented yet"))
	_credits_button.pressed.connect(func() -> void: print("Credits not implemented yet"))
	_exit_button.pressed.connect(_on_exit_pressed)
	_continue_button.disabled = not SaveManager.has_save()

func _on_campaign_pressed() -> void:
	SceneManager.change_scene("res://scenes/ui/world_map.tscn")

func _on_continue_pressed() -> void:
	GameManager.change_state(GameManager.GameState.WORLD_MAP)
	SceneManager.change_scene("res://scenes/ui/world_map.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
