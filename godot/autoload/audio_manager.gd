extends Node

## Central audio playback hub. Owns a music player and a round-robin pool of
## SFX players so multiple sounds can overlap without cutting each other off.

@onready var _music_player: AudioStreamPlayer = $MusicPlayer

var _sfx_players: Array[AudioStreamPlayer] = []
var _next_sfx_index: int = 0

func _ready() -> void:
	for child in $SFXPlayers.get_children():
		_sfx_players.append(child)

func play_music(stream: AudioStream, fade_in_time: float = 0.5) -> void:
	if stream == null:
		return
	_music_player.stream = stream
	_music_player.volume_db = -80.0 if fade_in_time > 0.0 else 0.0
	_music_player.play()
	if fade_in_time > 0.0:
		var tween := create_tween()
		tween.tween_property(_music_player, "volume_db", 0.0, fade_in_time)

func stop_music(fade_out_time: float = 0.5) -> void:
	if fade_out_time <= 0.0:
		_music_player.stop()
		return
	var tween := create_tween()
	tween.tween_property(_music_player, "volume_db", -80.0, fade_out_time)
	tween.tween_callback(_music_player.stop)

func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	if stream == null or _sfx_players.is_empty():
		return
	var player := _sfx_players[_next_sfx_index]
	_next_sfx_index = (_next_sfx_index + 1) % _sfx_players.size()
	player.stream = stream
	player.volume_db = volume_db
	player.play()
