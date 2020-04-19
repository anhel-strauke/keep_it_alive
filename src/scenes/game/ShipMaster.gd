extends Node
class_name ShipMaster

var world: GameWorld = null
var tilemap: WaterTileMap = null
var spawners: Array = []
var ships: Array = []
var water_switches = []

const ShipScene = preload("res://scenes/game/characters/Ship.tscn")

func _ready() -> void:
	var node = get_parent()
	while node:
		if node is GameWorld:
			world = node as GameWorld
			break
		node = node.get_parent()
	if not world:
		print("ERROR! ShipMaster must live inside GameWorld, but no GameWorld found.")
		return
	_find_tilemap(world)
	_collect_spawners(world)
	_collect_water_switches(world)


func _find_tilemap(node: Node) -> bool:
	for child in node.get_children():
		if child is WaterTileMap:
			tilemap = child as WaterTileMap
			tilemap.connect("tile_switched", self, "update_all_ship_paths")
			return true
		else:
			if _find_tilemap(child):
				return true
	return false


func _collect_spawners(node: Node) -> void:
	for child in node.get_children():
		if child is ShipSpawner:
			var spawner = child as ShipSpawner
			spawner.connect("spawn_ship_at", self, "create_ship_at")
			spawners.append(spawner)
		else:
			_collect_spawners(child)


func _collect_water_switches(node: Node) -> void:
	for child in node.get_children():
		if child is WaterSwitch:
			var water_sw = child as WaterSwitch
			water_sw.connect("clicked_at", tilemap, "switch_tile_at")
			water_switches.append(water_sw)
		else:
			_collect_water_switches(child)


func create_ship_at(global_pos: Vector2) -> void:
	var ship := ShipScene.instance()
	world.add_child(ship)
	ships.append(ship)
	ship.connect("dead_end_reached", self, "draw_ship")
	ship.global_position = global_pos
	update_ship_path(ship)


func draw_ship(ship: Ship) -> void:
	var i = ships.find(ship)
	if i >= 0:
		ships.remove(i)
	ship.queue_free()


func update_ship_path(ship: Ship) -> void:
	var glob_ship_pos = ship.global_position
	var path = tilemap.build_path(glob_ship_pos)
	ship.path = path


func update_all_ship_paths(tile_pos: Vector2) -> void:
	for ship in ships:
		update_ship_path(ship)
