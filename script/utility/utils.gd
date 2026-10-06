extends Node

## Get Key ##
static func getKey(Key):
	return InputMap.action_get_events(Key)[0].as_text().trim_suffix(" - Physical")

## Disable Inputs ##
var input = true

func disableInput():
	input = false

func enableInput():
	input = true

func _input(event: InputEvent) -> void:
	if !input:
		get_viewport().set_input_as_handled()
