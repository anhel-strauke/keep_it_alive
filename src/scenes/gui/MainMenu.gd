extends Node2D

onready var buttons = [$buttons/start_button, $buttons/credits_button, $buttons/exit_button]


var jump_to = ""
onready var black_animator = $black/black_anim_player
onready var hiscore = $HiScore


func _ready():
	Global.load_hiscore()
	if OS.get_name() == "HTML5":
		var i = len(buttons) - 1
		buttons[i].queue_free()
		buttons.remove(i)
	Global.get_root_scene().play_music()
	hiscore.text = str(Global.hi_score)


func _input(event):
	if not event is InputEventMouseButton:
		return
	var mouse_event := event as InputEventMouseButton
	if not mouse_event.pressed:
		return
	if mouse_event.button_index != BUTTON_LEFT:
		return
	for i in range(len(buttons)):
		var button = buttons[i]
		var mouse_pos = button.get_local_mouse_position()
		if button.get_rect().has_point(mouse_pos):
			do_menu_command(i)
			break


func do_menu_command(index: int) -> void:
	match index:
		0:
			start_game()
		1:
			show_credits()
		2:
			get_tree().quit()
	$buttons.set_process_input(false)


func start_game() -> void:
	jump_to = "res://scenes/game/GameWorld.tscn"
	black_animator.play("disappear")


func show_credits():
	jump_to = "res://scenes/gui/Credits.tscn"
	black_animator.play("disappear")


func finish_transition() -> void:
	Global.get_root_scene().load_scene(jump_to)
