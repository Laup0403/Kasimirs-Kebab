extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.speed_scale = randf()
	$AnimatedSprite2D.play("default")
