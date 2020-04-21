extends SpawnLord

enum {
	PHASE_1,
	PHASE_2,
	PHASE_2_REPEAT,
	PHASE_3
}

var phase = PHASE_1
var water_switch_wrong = true
var first_spawner: ShipSpawner = null
var water_switch: WaterSwitch = null
var ship_master: ShipMaster = null
var life_counter = null
var tries = 0
export(NodePath) var first_spawner_name: String = ""
export(NodePath) var water_switch_name: String = ""
export(NodePath) var ship_master_name: String = ""
export(NodePath) var life_counter_name: String = ""

onready var anim_player = $tutorial_anims

func initialize() -> void:
	first_spawner = get_node(first_spawner_name)
	first_spawner.coat_color = 0
	first_spawner.mode = 0
	water_switch = get_node(water_switch_name)
	water_switch.auto_switch_time = 60.0
	anim_player.play("enter_pennywise")
	ship_master = get_node(ship_master_name)
	ship_master.set_switches_enabled(false)
	life_counter = get_node(life_counter_name)
	tries = life_counter.value


func do_process(delta: float) -> void:
	pass


func _on_water_switch_clicked(_pos: Vector2) -> void:
	water_switch_wrong = not water_switch_wrong
	$tutorial_arrows_1.visible = water_switch_wrong
	$tutorial_arrows_2.visible = not water_switch_wrong
	$click_arrow.visible = water_switch_wrong


func tutorial_phase_2() -> void:
	first_spawner.spawn()
	phase = PHASE_2
	anim_player.play("tutorial_phase_2")

func show_arrows() -> void:
	$tutorial_arrows_1.visible = true
	water_switch.enabled = true
	$click_arrow.visible = water_switch_wrong
	water_switch.connect("clicked_at", self, "_on_water_switch_clicked")


func _on_first_ship_detect_area_entered(area):
	if enabled:
		water_switch.disconnect("clicked_at", self, "_on_water_switch_clicked")
		$tutorial_arrows_1.visible = false
		$tutorial_arrows_2.visible = false
		$click_arrow.visible = false
		phase = PHASE_3
		ship_master.connect("hunt_success", self, "_on_hunt_success")


func _on_first_ship_wrong_detect_area_entered(area):
	if enabled:
		$tutorial_arrows_1.visible = true
		$tutorial_arrows_2.visible = false
		$click_arrow.visible = false
		water_switch.enabled = false
		phase = PHASE_2_REPEAT
		ship_master.connect("hunt_failed", self, "_on_hunt_failed")


func _on_hunt_failed() -> void:
	tries -= 1
	if tries > 0:
		ship_master.disconnect("hunt_failed", self, "_on_hunt_failed")
		anim_player.play("tutorial_failed")
		$tutorial_arrows_1.visible = false
		$tutorial_arrows_2.visible = false
		$click_arrow.visible = false
		water_switch.disconnect("clicked_at", self, "_on_water_switch_clicked")


func _on_hunt_success() -> void:
	ship_master.disconnect("hunt_success", self, "_on_hunt_success")
	ship_master.disconnect("hunt_failed", self, "_on_hunt_failed")
	ship_master.set_switches_enabled(true)
	water_switch.auto_switch_time = 4.0
	first_spawner.coat_color = -1
	emit_signal("finished")
	set_process(false)

