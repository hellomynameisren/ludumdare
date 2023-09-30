extends Node2D

class_name level

var lava_block_scene = preload("res://liquid/lava_block.tscn")
var breakable_block_scene = preload("res://liquid/breakable_wall.tscn")




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func replace_tiles():
	for x in range($TileMap.get_used_rect().size.x):
		for y in range($TileMap.get_used_rect().size.y):
			var tile_coord = Vector2(x, y)
			var tile_id = $TileMap.get_cell_source_id(0, tile_coord)
			if tile_id == 1:
				var position = $TileMap.map_to_local(tile_coord + Vector2(1/2, 1/2))
				var lava_instance = lava_block_scene.instantiate()
				lava_instance.global_position = position
				self.add_child(lava_instance)
				$TileMap.set_cell(0, tile_coord, -1)
			if tile_id == 2:
				var position = $TileMap.map_to_local(tile_coord + Vector2(1/2, 1/2))
				var breakable_instance = breakable_block_scene.instantiate()
				breakable_instance.global_position = position
				self.add_child(breakable_instance)
				$TileMap.set_cell(0, tile_coord, -1)
