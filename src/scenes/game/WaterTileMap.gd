extends TileMap
class_name WaterTileMap


enum {
	NO_DIRECTION,
	N,
	E,
	S,
	W
}

const TILE_DIRECTIONS = [
	[E, E],  [W, W],  [S, S],  [N, N],
	[E, S],  [N, W],  [S, W],  [E, N],
	[W, N],  [S, E],  [N, E],  [W, S]
]


signal tile_switched(tile_pos)
signal tile_switch_failed(tile_pos)


func _path_contains_point(path: PoolVector2Array, point: Vector2) -> bool:
	for path_point in path:
		if path_point == point:
			return true
	return false


func _get_neighbour_tile_pos(tile_pos: Vector2, direction) -> Vector2:
	match direction:
		N: return Vector2(tile_pos.x, tile_pos.y - 1)
		E: return Vector2(tile_pos.x + 1, tile_pos.y)
		S: return Vector2(tile_pos.x, tile_pos.y + 1)
		W: return Vector2(tile_pos.x - 1, tile_pos.y)
	return Vector2.INF


func _is_water_tile(tile_type: int) -> bool:
	return tile_type >= 0 and tile_type < len(TILE_DIRECTIONS)


func _tile_top_left(tile_pos: Vector2) -> Vector2:
	return Vector2(tile_pos.x * cell_size.x, tile_pos.y * cell_size.y)


func _half_size() -> Vector2:
	return Vector2(cell_size.x / 2, cell_size.y / 2)


func _to_tile_coords(tile_pos: Vector2, loc_point: Vector2) -> Vector2:
	var tile_top_left = _tile_top_left(tile_pos)
	return loc_point - tile_top_left
	

func _get_quadrant(point: Vector2, cell_size: float) -> int:
	var is_sw_half = (point.x > point.y)
	var border_y = cell_size - point.x
	var is_se_half = point.y < border_y
	if is_sw_half:
		if is_se_half:
			return S
		else:
			return W
	else:
		if is_se_half:
			return E
		else:
			return N


func _neighbour_water_tile_pos(tile_pos: Vector2) -> Vector2:
	var this_tile_type = get_cellv(tile_pos)
	var dir_from_this = TILE_DIRECTIONS[this_tile_type][1]
	var neightbour_pos = _get_neighbour_tile_pos(tile_pos, dir_from_this)
	if neightbour_pos != Vector2.INF:
		var neighb_tile_type = get_cellv(neightbour_pos)
		if _is_water_tile(neighb_tile_type):
			var neighb_in_direction = TILE_DIRECTIONS[neighb_tile_type][0]
			if neighb_in_direction == dir_from_this:
				return neightbour_pos
			else:
				print("WARNING! Directions conflict: ", tile_pos, " and ", neightbour_pos, "; dirs are ", dir_from_this, " and ", neighb_in_direction)
		else:
			return neightbour_pos
	else:
		print("No neighbour for: ", tile_pos, " at ", dir_from_this)
	return Vector2.INF


func closest_tile_pos(glob_point: Vector2) -> Vector2:
	var loc_point = to_local(glob_point)
	var tile_pos = world_to_map(loc_point)
	var tile_center = _tile_top_left(tile_pos) + _half_size()
	if loc_point.distance_to(tile_center) < 0.5:
		return tile_pos
	var tile_type = get_cellv(tile_pos)
	if not _is_water_tile(tile_type):
		return tile_pos
	var tile_in_dir = TILE_DIRECTIONS[tile_type][0]
	var tile_point = _to_tile_coords(tile_pos, loc_point)
	var quadrant = _get_quadrant(tile_point, cell_size.x)
	if quadrant == tile_in_dir:
		return tile_pos
	return _neighbour_water_tile_pos(tile_pos)


func glob_center_of_tile(tile_pos: Vector2) -> Vector2:
	var top_left = _tile_top_left(tile_pos)
	return to_global(top_left + _half_size())


func next_tile_pos(tile_pos: Vector2) -> Vector2:
	var this_tile_type = get_cellv(tile_pos)
	if _is_water_tile(this_tile_type):
		return _neighbour_water_tile_pos(tile_pos)
	return Vector2.INF


func build_path(glob_start: Vector2) -> PoolVector2Array:
	var path := PoolVector2Array()
	var tile_pos := closest_tile_pos(glob_start)
	while tile_pos != Vector2.INF:
		var glob_tile := glob_center_of_tile(tile_pos)
		if _path_contains_point(path, glob_tile):
			print("Cycle found")
			break
		path.append(glob_tile)
		tile_pos = next_tile_pos(tile_pos)
	if path.size() > 0 and path[0] != glob_start:
		path.insert(0, glob_start)
	return path


func _next_direction(dir: int) -> int:
	match dir:
		N: return E
		E: return S
		S: return W
		W: return N
	return NO_DIRECTION


func _opposite_direction(dir: int) -> int:
	match dir:
		N: return S
		E: return W
		S: return N
		W: return E
	return NO_DIRECTION


func _find_tile_type(in_dir: int, out_dir: int) -> int:
	for i in range(len(TILE_DIRECTIONS)):
		var dirs = TILE_DIRECTIONS[i]
		if dirs[0] == in_dir and dirs[1] == out_dir:
			return i
	return -1


func switch_tile_at(global_point: Vector2) -> void:
	var tile_pos = world_to_map(to_local(global_point))
	var tile_type = get_cellv(tile_pos)
	if not _is_water_tile(tile_type):
		return
	var this_in_dir = TILE_DIRECTIONS[tile_type][0]
	var this_out_dir = TILE_DIRECTIONS[tile_type][1]
	var new_out_dir := _next_direction(this_out_dir)
	while new_out_dir != this_out_dir:
		if new_out_dir != _opposite_direction(this_in_dir):
			var neighb_tile_pos = _get_neighbour_tile_pos(tile_pos, new_out_dir)
			if neighb_tile_pos != Vector2.INF:
				var neighb_type = get_cellv(neighb_tile_pos)
				if _is_water_tile(neighb_type):
					if new_out_dir == TILE_DIRECTIONS[neighb_type][0]:
						var new_tile_type = _find_tile_type(this_in_dir, new_out_dir)
						if _is_water_tile(new_tile_type):
							set_cellv(tile_pos, new_tile_type)
							emit_signal("tile_switched", tile_pos)
							return
		new_out_dir = _next_direction(new_out_dir)
	emit_signal("tile_switch_failed", tile_pos)
