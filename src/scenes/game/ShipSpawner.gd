extends Node2D
class_name ShipSpawner, "res://textures/sprites/ship.png"

enum SpawnerMode {
	OFF,
	TIMER,
	MANUAL
}

export var delay: float = 5.0
export var only_once: bool = false
export(int, "Off", "Timer", "Manual") var mode: int = SpawnerMode.OFF

var time = 0.0

signal spawn_ship_at(global_pos)

func _ready():
	$icon.visible = false

func _process(delta: float) -> void:
	if mode == SpawnerMode.OFF:
		return
	time += delta
	if time > delay:
		time = 0.0
		if mode == SpawnerMode.TIMER:
			spawn()
			if only_once:
				mode = SpawnerMode.OFF

func spawn():
	print("Spawning ship at ", global_position)
	emit_signal("spawn_ship_at", global_position)
