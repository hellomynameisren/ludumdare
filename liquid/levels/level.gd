extends Node2D

class_name level

var wall_scene = preload("res://liquid/wall_block.tscn")
var lava_block_scene = preload("res://liquid/lava_block.tscn")
var breakable_block_scene = preload("res://liquid/breakable_wall.tscn")
var gravel_scene = preload("res://liquid/gravel.tscn")
var weak_scene = preload("res://liquid/weak_block.tscn")
var dancing_player_scene = preload("res://liquid/dancing_player.tscn")


var level_ended = false

func go_to_game_over_scene():
	if not level_ended:
		level_ended = true
		var playarea = get_parent()
		if playarea is play_area:
			playarea.reset_level()
		else:
			get_tree().change_scene_to_file("res://liquid/game_over.tscn")
	
func go_to_you_win_scene():
	if not level_ended:
		level_ended = true
		$BackgroundColor.z_index = 100
		var player = get_node("Player")
		var goal = get_node("Goal")
		player.z_index = 300
		goal.z_index = 200
		goal.global_position.x = player.global_position.x + goal.scale.x * 50
		
		goal.global_position.y = player.global_position.y + 30
		
		#player.get_node("AnimationTree").set_active(false)
		#player.get_node("AnimationPlayer").play("dance")
		var dancing_player = dancing_player_scene.instantiate()
		add_child(dancing_player)
		dancing_player.global_position = player.global_position
		player.get_node("Sprite2D").visible = false
		
		
		# player.get_node("Camera2D").enabled = false
		await get_tree().create_timer(4.0).timeout
		var playarea = get_parent()
		if playarea is play_area:
			playarea.next_level()
		else:
			get_tree().change_scene_to_file("res://liquid/you_win.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	replace_tiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func replace_tiles():
	var tilemap = get_node("TileMap")
	var lava_map = get_node("LavaMap")
	if not tilemap:
		return
	var used_rect = tilemap.get_used_rect()
	for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var tile_coord = Vector2(x, y)
			var local_pos = tilemap.map_to_local(tile_coord + Vector2(1/2, 1/2))
			var global_pos = tilemap.to_global(local_pos)
			var tile_id = tilemap.get_cell_source_id(0, tile_coord)
			# print("tile " + str(tile_id) + " loc " + str(tile_coord))
			#if tile_id == 0:
			#	var position = $TileMap.map_to_local(tile_coord + Vector2(1/2, 1/2))
			#	var wall_instance = wall_scene.instantiate()
			#	wall_instance.global_position = global_pos
			#	self.add_child(wall_instance)
			#	$TileMap.set_cell(0, tile_coord, -1)
			if tile_id == 1:
				if lava_map:
					lava_map.put_lava_at(tile_coord)
				else:
					# print("spawn lava at " + str(position))
					var lava_instance = lava_block_scene.instantiate()
					lava_instance.global_position = global_pos
					self.add_child(lava_instance)
					lava_instance.global_position = global_pos
					tilemap.set_cell(0, tile_coord, -1)
			if tile_id == 2:
				var frame = tilemap.get_cell_tile_data(0, tile_coord).get_custom_data_by_layer_id(0)
				var breakable_instance = breakable_block_scene.instantiate()
				breakable_instance.global_position = global_pos
				breakable_instance.get_node("Sprite2D").frame = frame
				self.add_child(breakable_instance)
				breakable_instance.global_position = global_pos
				tilemap.set_cell(0, tile_coord, -1)
			if tile_id == 3:
				var gravel_instance = gravel_scene.instantiate()
				gravel_instance.global_position = global_pos
				self.add_child(gravel_instance)
				gravel_instance.global_position = global_pos
				tilemap.set_cell(0, tile_coord, -1)
			if tile_id == 4:
				var weak_instance = weak_scene.instantiate()
				weak_instance.global_position = global_pos
				self.add_child(weak_instance)
				weak_instance.global_position = global_pos
				tilemap.set_cell(0, tile_coord, -1)
