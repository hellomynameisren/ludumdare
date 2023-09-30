extends Node2D

class_name level

var wall_scene = preload("res://liquid/wall_block.tscn")
var lava_block_scene = preload("res://liquid/lava_block.tscn")
var breakable_block_scene = preload("res://liquid/breakable_wall.tscn")
var gravel_scene = preload("res://liquid/gravel.tscn")
var weak_scene = preload("res://liquid/weak_block.tscn")




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func replace_tiles():
	var used_rect = $TileMap.get_used_rect()
	for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var tile_coord = Vector2(x, y)
			var tile_id = $TileMap.get_cell_source_id(0, tile_coord)
			# print("tile " + str(tile_id) + " loc " + str(tile_coord))
			#if tile_id == 0:
			#	var position = $TileMap.map_to_local(tile_coord + Vector2(1/2, 1/2))
			#	var wall_instance = wall_scene.instantiate()
			#	wall_instance.global_position = position
			#	self.add_child(wall_instance)
			#	$TileMap.set_cell(0, tile_coord, -1)
			if tile_id == 1:
				var position = $TileMap.map_to_local(tile_coord + Vector2(1/2, 1/2))
				var lava_instance = lava_block_scene.instantiate()
				lava_instance.global_position = position
				self.add_child(lava_instance)
				$TileMap.set_cell(0, tile_coord, -1)
			if tile_id == 2:
				var frame = $TileMap.get_cell_tile_data(0, tile_coord).get_custom_data_by_layer_id(0)
				var position = $TileMap.map_to_local(tile_coord + Vector2(1/2, 1/2))
				var breakable_instance = breakable_block_scene.instantiate()
				breakable_instance.global_position = position
				breakable_instance.get_node("Sprite2D").frame = frame
				self.add_child(breakable_instance)
				$TileMap.set_cell(0, tile_coord, -1)
			if tile_id == 3:
				var position = $TileMap.map_to_local(tile_coord + Vector2(1/2, 1/2))
				var gravel_instance = gravel_scene.instantiate()
				gravel_instance.global_position = position
				self.add_child(gravel_instance)
				$TileMap.set_cell(0, tile_coord, -1)
			if tile_id == 4:
				var position = $TileMap.map_to_local(tile_coord + Vector2(1/2, 1/2))
				var weak_instance = weak_scene.instantiate()
				weak_instance.global_position = position
				self.add_child(weak_instance)
				$TileMap.set_cell(0, tile_coord, -1)
