# LevelManager.gd
extends Node

@export var tutorial_level: PackedScene # I dont knwo hwo to drag tutoiral level over top. 
@export var level_pool: Array[PackedScene]  # for rogue-lite later
@onready var GridManager: 2DNODE = # I dont knwo how to load this 

var current_level: Node2D

func load_level(scene: PackedScene) -> void:
	if current_level:
		current_level.queue_free()
		await current_level.tree_exited

	current_level = scene.instantiate()
	get_tree().current_scene.add_child(current_level)

	var tilemap_layer: TileMapLayer = current_level.get_node("TileMapLayer")
	GridManager.set_tilemap_layer(tilemap_layer)

func load_tutorial() -> void:
	load_level(tutorial_level)
