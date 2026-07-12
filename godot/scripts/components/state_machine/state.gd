extends Node
class_name State

## Base class for individual states used by StateMachine. Override the
## lifecycle methods below; the FSM calls them, nothing else should.

signal transitioned(new_state_name: StringName)

func enter(_previous_state: StringName) -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
