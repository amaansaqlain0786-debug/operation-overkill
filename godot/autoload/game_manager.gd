extends Node

## Central game-flow state container. Other systems read `state` and react to
## `state_changed`; this script does not implement mission/combat logic itself.

signal state_changed(previous_state: GameState, new_state: GameState)
signal paused_changed(is_paused: bool)

enum GameState {
	BOOT,
	MAIN_MENU,
	WORLD_MAP,
	MISSION_BRIEFING,
	IN_MISSION,
	EXTRACTION,
	REWARDS,
	GAME_OVER,
}

var state: GameState = GameState.BOOT
var current_operative: OperativeData
var current_mission_id: String = ""
var is_paused: bool = false

func change_state(new_state: GameState) -> void:
	if new_state == state:
		return
	var previous_state := state
	state = new_state
	state_changed.emit(previous_state, new_state)

func set_paused(value: bool) -> void:
	if value == is_paused:
		return
	is_paused = value
	get_tree().paused = value
	paused_changed.emit(value)
