extends Node2D


onready var hi_score = $background/hi_score
onready var black_animator = $black/black_anim_player

func _ready():
	hi_score.text = str(Global.last_score)
	Global.get_root_scene().stop_music()


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			finish()
	elif event is InputEventAction:
		if event.is_action_released("ui_accept") or event.is_action_released("ui_cancel"):
			finish()


func finish():
	set_process_input(false)
	black_animator.play("disappear")


func run_main_menu():
	Global.get_root_scene().load_scene("res://scenes/gui/MainMenu.tscn")
