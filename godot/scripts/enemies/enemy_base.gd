extends CharacterBody2D
class_name EnemyBase

## Shared skeleton for all enemy types. Concrete enemies (Rifleman,
## Shotgunner, etc.) inherit this scene and supply their own EnemyData; no AI
## or combat logic is implemented here yet.

@export var enemy_data: EnemyData
