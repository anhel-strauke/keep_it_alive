extends Node2D
class_name Kid

enum {
	INITIAL,
	MOVE,
	IDLE,
	RUN_AWAY,
	RUN_TO_DEATH
}

enum {
	LEFT,
	RIGHT
}

var ship: Ship = null setget set_ship
var state: int = INITIAL
var time: float = 0.0
var speed: float = 0.0
var run_away_target := Vector2.ZERO
var death_target := Vector2.ZERO
var direction := LEFT

const minimal_distance = 24.0
const maximum_distance = 72.0
const min_speed = 20.0
const max_speed = 30.0
const run_away_speed = 55.0

onready var anim_player = $AnimationPlayer
onready var sprite = $sprite

signal successfully_ran_away(kid)

func set_ship(sh: Ship) -> void:
	ship = sh
	if ship:
		state = IDLE
		time = 2.0
		anim_player.play("idle")
	else:
		run_away()


func move(target: Vector2, amount: float):
	var new_pos = global_position.move_toward(target, amount)
	if new_pos.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	global_position = new_pos


func _process(delta: float) -> void:
	match state:
		MOVE:
			if not ship:
				return
			time -= delta
			var dist = _distance_to_ship()
			if time < 0.0 or dist < minimal_distance:
				time = 1.0
				state = IDLE
				anim_player.play("idle")
			else:
				move(ship.global_position, speed * delta)
		IDLE:
			if not ship:
				return
			time -= delta
			var dist = _distance_to_ship()
			if dist > maximum_distance or time < 0.0:
				time = 4.0
				state = MOVE
				anim_player.play("walk")
				speed = (max_speed - min_speed) * randf() + min_speed
		RUN_AWAY:
			if _is_run_away_target_reached():
				emit_signal("successfully_ran_away", self)
				state = INITIAL
			else:
				move(run_away_target, speed * delta)
		RUN_TO_DEATH:
			move(death_target, speed * delta)


func _distance_to_ship() -> float:
	if not ship:
		return 0.0
	return global_position.distance_to(ship.global_position)


func _is_run_away_target_reached():
	match direction:
		LEFT:
			return global_position.x < run_away_target.x
		RIGHT:
			return global_position.x > run_away_target.x


func run_away() -> void:
	state = RUN_AWAY
	anim_player.play("walk")
	if global_position.x < 160:
		run_away_target = Vector2(-32.0, global_position.y)
		direction = LEFT
	else:
		run_away_target = Vector2(320.0 + 32.0, global_position.y)
		direction = RIGHT
	speed = run_away_speed


func run_to_death(global_point: Vector2) -> void:
	state = RUN_TO_DEATH
	anim_player.play("walk")
	death_target = global_point
	speed = max_speed
