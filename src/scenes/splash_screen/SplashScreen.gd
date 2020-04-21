extends Node2D


export (String, FILE, "*.tscn") var next_scene := ""
export var animation_fadeout_moment := 0.0

onready var anim_player = $AnimationPlayer


func _ready() -> void:
	if animation_fadeout_moment == 0.0:
		animation_fadeout_moment = anim_player.current_animation_length - 0.3


func _jump_to_exit() -> void:
	if not anim_player.is_playing():
		return
	if anim_player.current_animation_position < animation_fadeout_moment:
		anim_player.seek(animation_fadeout_moment, true)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == BUTTON_LEFT:
			_jump_to_exit()
	elif  (Input.is_action_just_pressed("ui_accept") or 
			Input.is_action_just_pressed("ui_cancel")):
				_jump_to_exit()


func _on_AnimationPlayer_animation_finished(anim_name):
	if len(next_scene) > 0:
		get_tree().change_scene(next_scene)
	else:
		get_tree().quit()
