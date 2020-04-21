extends Node2D


func _go_to_main_menu():
	Global.get_root_scene().load_scene("res://scenes/gui/MainMenu.tscn")


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		$back/alarm_exit.play("stop")
		set_process_input(false)
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		$back/alarm_exit.play("stop")
		set_process_input(false)
