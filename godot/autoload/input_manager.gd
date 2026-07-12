extends Node

## Runtime input abstraction layer: tracks which device the player last used
## (for on-screen prompts) and supports rebinding actions on top of the
## project's InputMap.

signal device_changed(is_gamepad: bool)

var is_gamepad_active: bool = false

var _default_events: Dictionary = {}

func _ready() -> void:
	for action in InputMap.get_actions():
		_default_events[action] = InputMap.action_get_events(action).duplicate()

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		_set_gamepad_active(true)
	elif event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		_set_gamepad_active(false)

func rebind_action(action_name: StringName, event: InputEvent) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

func reset_action_to_default(action_name: StringName) -> void:
	if not _default_events.has(action_name):
		return
	InputMap.action_erase_events(action_name)
	for event in _default_events[action_name]:
		InputMap.action_add_event(action_name, event)

func _set_gamepad_active(value: bool) -> void:
	if value == is_gamepad_active:
		return
	is_gamepad_active = value
	device_changed.emit(value)
