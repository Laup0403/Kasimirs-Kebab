extends Node2D

@onready var danke = $"Danke oida"
var timer = 1

func _process(delta: float) -> void:
	if danke.visible: 
		timer -= delta
		if Input.is_anything_pressed() && timer <= 0: danke.hide(); timer = 1
	else: 
		timer -= delta
		if Input.is_anything_pressed() && timer <= 0: get_tree().call_deferred("change_scene_to_file", "res://scenes/menu.tscn")
