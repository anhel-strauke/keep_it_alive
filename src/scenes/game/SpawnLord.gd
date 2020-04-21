extends Node
class_name SpawnLord

var spawners: Array = []
export var enabled: bool = false

signal finished()


func _collect_spawners_from(node: Node) -> void:
	for child in node.get_children():
		if child is ShipSpawner:
			spawners.append(child as ShipSpawner)
		else:
			_collect_spawners_from(child)


func collect_spawners(node: Node) -> void:
	_collect_spawners_from(node)
	if spawners.size() > 0:
		initialize()


func get_spawner(name: String) -> ShipSpawner:
	for spawner in spawners:
		if spawner.name == name:
			return spawner
	return null


func do_process(delta: float) -> void:
	pass
	

func initialize() -> void:
	pass


func _process(delta):
	if spawners.size() > 0 and enabled:
		do_process(delta)
