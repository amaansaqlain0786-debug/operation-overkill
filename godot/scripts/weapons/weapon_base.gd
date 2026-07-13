extends Node2D
class_name WeaponBase

## Contract for all weapons. Concrete weapon scenes inherit this and override
## fire()/reload(). current_ammo/magazine_size/ammo_changed live here (not on
## a specific weapon) so any future weapon can plug into ammo HUD wiring the
## same way, without LevelBase needing to know which concrete weapon it is.

signal ammo_changed(current: int, max_value: int)

@export var weapon_data: WeaponData

@onready var muzzle_point: Marker2D = $MuzzlePoint

var current_ammo: int = 0
var magazine_size: int = 0

func fire() -> void:
	pass

func reload() -> void:
	pass
