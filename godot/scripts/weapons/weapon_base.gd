extends Node2D
class_name WeaponBase

## Contract for all weapons. Concrete weapon scenes inherit this and override
## fire()/reload(); the actual firing logic belongs to the Core Combat
## milestone, not this scaffolding pass.

@export var weapon_data: WeaponData

@onready var muzzle_point: Marker2D = $MuzzlePoint

func fire() -> void:
	pass

func reload() -> void:
	pass
