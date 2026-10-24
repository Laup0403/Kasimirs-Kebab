extends Node2D

@onready var danke = $"Danke oida"
var timer = 1
var change = false

func _ready() -> void:
	Utils.mainmenutheme.playing = true

func _process(delta: float) -> void:
	if danke.visible: 
		timer -= delta
		if Input.is_anything_pressed() && timer <= 0: danke.hide(); timer = 1
	else:
		timer -= delta
		if Input.is_anything_pressed() && timer <= 0 && not change: change = true; get_tree().call_deferred("change_scene_to_file", "res://scenes/menu.tscn")
