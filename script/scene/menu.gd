extends Node2D

## Main Menu ##
func _main_start() -> void:
	get_tree().change_scene_to_file("res://scenes/chapter1.tscn")
func _main_load() -> void:
	$Buttons/Main.visible = false
	$Buttons/Load.visible = true
func _main_settings() -> void:
	$Buttons/Main.visible = false
	$Buttons/Settings.visible = true
func _main_exit() -> void:
	get_tree().quit(0)

## Load Menu ##
func _load_chapter1() -> void:
	get_tree().change_scene_to_file("res://scenes/chapter1.tscn")
func _load_chapter2() -> void:
	get_tree().change_scene_to_file("res://scenes/chapter2.tscn")
func _load_chapter3() -> void:
	get_tree().change_scene_to_file("res://scenes/chapter3.tscn")
func _load_chapter4() -> void:
	get_tree().change_scene_to_file("res://scenes/chapter4.tscn")
func _load_chapter5() -> void:
	get_tree().change_scene_to_file("res://scenes/chapter5.tscn")
func _load_back() -> void:
	$Buttons/Main.visible = true
	$Buttons/Load.visible = false

## Settings Menu ##
func _settings_mobile() -> void:
	if not Utils.mobile:
		Utils.mobile = true
		$Buttons/Settings/Mobile/Label.text = "Mobile: on"
	else:
		Utils.mobile = false
		$Buttons/Settings/Mobile/Label.text = "Mobile: off"
func _settings_back() -> void:
	$Buttons/Main.visible = true
	$Buttons/Settings.visible = false

var recording = "nothing"

func _input(event: InputEvent) -> void:
	if recording == "nothing":
		return
	
	var label = $Buttons/Settings.get_node(recording).get_node("Label")
	label.text = "recording..."
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		InputMap.action_erase_events(recording)
		InputMap.action_add_event(recording, event)
		
		label.text = recording + ": " + event.as_text().trim_suffix(" - Physical")
		
		recording = "nothing"
		get_viewport().set_input_as_handled()

func _settings_up() -> void:
	recording = "Up"
func _settings_down() -> void:
	recording = "Down"
func _settings_left() -> void:
	recording = "Left"
func _settings_right() -> void:
	recording = "Right"
func _settings_action1() -> void:
	recording = "Action1"
func _settings_action2() -> void:
	recording = "Action2"
