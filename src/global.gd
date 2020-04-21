extends Node


var hi_score := 0
var last_score := 0


func save_hiscore():
	var save_file = File.new()
	var err = save_file.open_encrypted_with_pass("user://savedata.bin", File.WRITE, OS.get_unique_id())
	if err != OK:
		return
	save_file.store_var(hi_score)
	save_file.close()


func load_hiscore():
	var save_file = File.new()
	var err = save_file.open_encrypted_with_pass("user://savedata.bin", File.READ, OS.get_unique_id())
	if err != OK:
		return
	hi_score = save_file.get_var()
	save_file.close()


func get_root_scene() -> RootScene:
	return get_tree().root.find_node("RootScene", true, false) as RootScene
