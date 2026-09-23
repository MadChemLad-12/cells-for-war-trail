# LevelManager.gd
@export var tutorial_level_scene: PackedScene
var current_level: Node2D

func load_level(scene: PackedScene) -> void:
	if current_level:
		current_level.queue_free()
	current_level = scene.instantiate()
	add_child(current_level)  # or wherever the level should live in the tree

	var tilemap_layer: TileMapLayer = current_level.get_node("TileMapLayer")
	GridManager.set_tilemap_layer(tilemap_layer)
