extends Node2D

@onready var MainButtons = $Buttons/Main
@onready var LoadButtons = $Buttons/Load
@onready var SettingsButtons = $Buttons/Settings
@onready var Übergang = $"Übergang"

var state = "Main"
var recording = "nothing"
var mouse = "none"

## For every Spalt in a menu an array and in the array the lines
var main = [
	[
		"Start",
		"Load",
		"Settings"
	],
	[
		"Exit"
	]
]
var load = [
	[
		"Chapter1",
		"Back"
	],
	[
		"Chapter2",
	]
]
var settings = [
	[
		"Up",
		"Down",
		"Left",
		"Right"
	],
	[
		"Action1",
		"Action2",
		"Back"
	]
]

func _process(delta: float) -> void:
	
	if !Utils.input: return
	
	## Setting variables ##
	var menu = main
	
	if state == "Main":
		menu = main
	elif state == "Load":
		menu = load
	elif state == "Settings":
		menu = settings
	
	var cm = menu.front().front()
	
	## If action1 ##
	if state == "Main":
		if Input.is_action_just_pressed("Action1") or Input.is_action_just_pressed("Mouse1"):
			if cm == "Start":
				Übergang.outro(func(): get_tree().change_scene_to_file("res://scenes/chapter1.tscn"))
			elif cm == "Load":
				state = "Load"
			elif cm == "Settings":
				state = "Settings"
			elif cm == "Exit":
				get_tree().quit()
	elif state == "Load" && (Input.is_action_just_pressed("Action1") or Input.is_action_just_pressed("Mouse1")):
		if cm == "Chapter1":
			Übergang.outro(func():get_tree().change_scene_to_file("res://scenes/chapter1.tscn"))
		elif cm == "Chapter2":
			Übergang.outro(func():get_tree().change_scene_to_file("res://scenes/chapter2.tscn"))
		elif cm == "Back":
			state = "Main"
	elif state == "Settings":
		for button in SettingsButtons.get_children():
			if button.has_node("Label") and button.name != "Back" :
				if button.name == recording:
					button.get_node("Label").text = "recording..."
				else:
					button.get_node("Label").text = button.name + ": "+ Utils.getKey(button.name)
		
		if Input.is_action_just_pressed("Action1") or Input.is_action_just_pressed("Mouse1"):
			if cm == "Back":
				state = "Main"
			else:
				recording = cm
	
	if recording == "nothing" && mouse == "none":
		if Input.is_action_just_pressed("Down"):
			move_down(menu.front())
		elif Input.is_action_just_pressed("Up"):
			move_up(menu.front())
		elif Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
			move_up(menu)
	if mouse != "none":
		while !menu.front().has(mouse):
			move_up(menu)
		while menu.front().front() != mouse:
			move_up(menu.front())
	
	buttonHover(cm)
	selectMenu()

## I HATE INPUTS ##
func _input(event: InputEvent) -> void:
	if recording != "nothing" && state == "Settings":
		if event is InputEventKey and event.is_pressed() and not event.is_echo():
			InputMap.action_erase_events(recording)
			InputMap.action_add_event(recording, event)
			recording = "nothing"
			get_viewport().set_input_as_handled()

func move_down(array):
	var item = array.pop_front()
	array.push_back(item)
func move_up(array):
	var item = array.pop_back()
	array.push_front(item)

func buttonHover(current):
	for button in get(state+"Buttons").get_children():
		if button.name == current:
			button.frame = 1
		else:
			button.frame = 0
func selectMenu():
	for menu in $Buttons.get_children():
		if menu.name == state:
			menu.visible = true
		else:
			menu.visible = false

func _mouse_exited() -> void:
	mouse = "none"

func _start_mouse_entered() -> void:
	mouse = "Start"
func _load_mouse_entered() -> void:
	mouse = "Load"
func _settings_mouse_entered() -> void:
	mouse = "Settings"
func _exit_mouse_entered() -> void:
	mouse = "Exit"
func _chapter1_mouse_entered() -> void:
	mouse = "Chapter1"
func _chapter2_mouse_entered() -> void:
	mouse = "Chapter2"
func _back_mouse_entered() -> void:
	mouse = "Back"
func _up_mouse_entered() -> void:
	mouse = "Up"
func _down_mouse_entered() -> void:
	mouse = "Down"
func _left_mouse_entered() -> void:
	mouse = "Left"
func _right_mouse_entered() -> void:
	mouse = "Right"
func _action1_mouse_entered() -> void:
	mouse = "Action1"
func _action2_mouse_entered() -> void:
	mouse = "Action2"
