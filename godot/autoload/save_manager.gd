extends Node

## Handles persistent save data (progression, unlocks) and user settings
## (audio levels, keybinds) via ConfigFile. No gameplay-specific fields are
## hardcoded here; callers pass plain dictionaries of values to store.

const SAVE_PATH := "user://savegame.cfg"
const SETTINGS_PATH := "user://settings.cfg"

func save_game(data: Dictionary) -> Error:
	var config := ConfigFile.new()
	for key in data.keys():
		config.set_value("save", key, data[key])
	return config.save(SAVE_PATH)

func load_game() -> Dictionary:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		return {}
	var data := {}
	for key in config.get_section_keys("save"):
		data[key] = config.get_value("save", key)
	return data

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)

func save_settings(data: Dictionary) -> Error:
	var config := ConfigFile.new()
	for key in data.keys():
		config.set_value("settings", key, data[key])
	return config.save(SETTINGS_PATH)

func load_settings() -> Dictionary:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_PATH)
	if err != OK:
		return {}
	var data := {}
	for key in config.get_section_keys("settings"):
		data[key] = config.get_value("settings", key)
	return data
