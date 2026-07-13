extends Node
class_name StateMachine

## Generic finite-state machine. Add State-derived nodes as children named
## after their state, set initial_state in the Inspector, and this drives
## whichever one is active.

@export var initial_state: NodePath

var current_state: State

var _states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			_states[child.name.to_lower()] = child
			child.transitioned.connect(transition_to)
	if _states.is_empty():
		push_warning("StateMachine at %s has no State children — no states will ever run." % get_path())
	if initial_state != NodePath():
		var start_state := get_node(initial_state) as State
		if start_state:
			current_state = start_state
			current_state.enter(&"")
	if current_state == null:
		push_error("StateMachine at %s never resolved a current_state (initial_state=%s) — it will not process anything. Check that Initial State is set in the Inspector and points to a valid State child." % [get_path(), initial_state])

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func transition_to(state_name: StringName) -> void:
	var key := String(state_name).to_lower()
	if not _states.has(key) or _states[key] == current_state:
		return
	var previous_name: StringName = current_state.name if current_state else &""
	if current_state:
		current_state.exit()
	current_state = _states[key]
	current_state.enter(previous_name)
