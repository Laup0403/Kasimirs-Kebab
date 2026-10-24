extends Node
var übergang: AudioStreamPlayer
var mainmenutheme: AudioStreamPlayer
var piepmatz: AudioStreamPlayer

func _ready() -> void:
	übergang = AudioStreamPlayer.new()
	add_child(übergang)
	übergang.stream = load("res://audio/übergang.ogg")
	
	mainmenutheme = AudioStreamPlayer.new()
	add_child(mainmenutheme)
	mainmenutheme.stream = load("res://audio/hans.ogg")
	
	piepmatz = AudioStreamPlayer.new()
	add_child(piepmatz)
	piepmatz.stream = load("res://audio/piepmatz.mp3")

## Get Key ##
static func getKey(Key):
	return InputMap.action_get_events(Key)[0].as_text().trim_suffix(" - Physical")

## Disable Inputs ##
var input = true
var mobile = false

func disableInput():
	input = false

func enableInput():
	input = true

func _input(event: InputEvent) -> void:
	if !input:
		get_viewport().set_input_as_handled()
