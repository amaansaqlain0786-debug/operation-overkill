extends Area2D
class_name ExtractionZone

## Win-condition trigger. Purely a detector — LevelBase decides what
## "reaching extraction" actually means (mission complete, transition, etc.).

signal player_entered

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()
