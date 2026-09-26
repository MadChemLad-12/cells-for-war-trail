# WeaponResource.gd
class_name WeaponResource
extends Resource

enum Slot { PRIMARY, SECONDARY }

@export var weapon_name: String
@export var slot: Slot
@export var max_ammo: int
@export var current_ammo: int
@export var range: int
@export var dice: Array[Die]
@export var upgrade_slots: int  # 2 for primary, 1 for secondary (2 if overclocked)
@export var upgrades: Array[UpgradeResource]
@export var is_overclocked: bool = false
@export var overclock_cost: int = 3
@export var overclock_bonus_ammo: int = 2  # brings secondary's 3 up to 5
