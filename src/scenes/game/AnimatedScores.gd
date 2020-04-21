extends Label


export var value: int setget set_value, get_value
export var speed_per_second: float = 500.0
export var flash_every: int = 10000

var _target_value: int = 0
var _display_value: float = 0
var _last_flash: int = 0

onready var anim_player = $AnimationPlayer


signal flashed()


func set_value(v: int) -> void:
	_target_value = v


func get_value() -> int:
	return _target_value


func _process(delta):
	if _target_value != _display_value:
		var dir: float = sign(_target_value - _display_value)
		var shift: float = speed_per_second * delta
		_display_value += dir * shift
		if dir > 0 and _display_value > _target_value:
			_display_value = _target_value
		elif dir < 0 and _display_value < _target_value:
			_display_value = _target_value
		text = str(int(_display_value))
		if _display_value >= (_last_flash + flash_every):
			_last_flash += flash_every
			anim_player.play("flash")
			emit_signal("flashed")
