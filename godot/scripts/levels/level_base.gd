extends Node2D
class_name LevelBase

## Structural template every mission/level scene inherits from. Provides the
## standard container nodes that later systems will populate; no mission
## logic runs yet.

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemies: Node2D = $Enemies
@onready var pickups: Node2D = $Pickups
@onready var destructibles: Node2D = $Destructibles
@onready var triggers: Node2D = $Triggers
