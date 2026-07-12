extends CharacterBody2D
class_name Player

## Skeleton only: node wiring and camera registration. Movement, combat and
## state-machine behavior are added in the Core Combat milestone.

@export var operative_data: OperativeData

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	CameraManager.register_camera(camera)
