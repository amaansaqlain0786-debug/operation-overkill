extends Node

## Handles transitions between top-level scenes (menus, world map, missions)
## with an optional fade and threaded loading so large level scenes don't
## hitch the main thread.

signal scene_change_started(scene_path: String)
signal scene_change_finished(scene_path: String)

@onready var _fade_rect: ColorRect = $CanvasLayer/FadeRect

var _is_loading: bool = false

func change_scene(scene_path: String, use_fade: bool = true) -> void:
	if _is_loading:
		return
	_is_loading = true
	scene_change_started.emit(scene_path)
	ResourceLoader.load_threaded_request(scene_path)
	if use_fade:
		await _fade_out()
	while ResourceLoader.load_threaded_get_status(scene_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	var packed_scene: PackedScene = ResourceLoader.load_threaded_get(scene_path)
	get_tree().change_scene_to_packed(packed_scene)
	if use_fade:
		await _fade_in()
	_is_loading = false
	scene_change_finished.emit(scene_path)

func _fade_out(duration: float = 0.25) -> void:
	_fade_rect.visible = true
	var tween := create_tween()
	tween.tween_property(_fade_rect, "color:a", 1.0, duration)
	await tween.finished

func _fade_in(duration: float = 0.25) -> void:
	var tween := create_tween()
	tween.tween_property(_fade_rect, "color:a", 0.0, duration)
	await tween.finished
	_fade_rect.visible = false
