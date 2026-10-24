extends Node2D

@onready var player = $Player
@onready var übergang = $"UI/Übergang"
@onready var textbox = $"UI/Textbox"
var theEnd = false
var timer = 0
var area = "none"
var endAnim = false
var audioEnd = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Utils.piepmatz.stop()
	player.position = Vector2(0.0,0.0)
	player.dir = 'u'
	player.canMove = false
	übergang.intro(func():
		$MainRoom/Wallbottom/Gatter.play("default")
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if theEnd:
		$TheEnd/Camera.position.x = player.position.x
		if endAnim:
			if timer > 0 and audioEnd:
				$TheEnd/Camera.zoom += Vector2(0.01,0.01)
			elif audioEnd:
				var Kasimir = $Kasimir
				if Kasimir.position.y >= -450.0:
					Kasimir.position.y -= 5
					if Kasimir.position.y <= player.position.y-16: player.position.y = Kasimir.position.y-16
				else:
					$UI/black.visible = true
					if Input.is_anything_pressed():
						var nextRes = load("res://scenes/win.tscn")
						var next = nextRes.instantiate()
						get_tree().root.add_child(next)
						queue_free()
			
			if audioEnd:
				timer -= delta
		elif area == "döner" and player.dir == 'u' and Input.is_action_just_pressed("Action1"):
			timer = 3.5
			endAnim = true
			player.canMove = false

func _gatter_finished() -> void:
	textbox.addText("Klaus", "Now there is no way back", func():player.canMove=true;$Audio.playing = true)

func _door(body: Node2D) -> void:
	if body == player:
		übergang.outro(
			func():
				player.position = Vector2(0.0,0.0)
				player.get_node("Camera2D").enabled = false
				$TheEnd/Camera.enabled = true
				player.canMove = true
				theEnd = true
				player.position = Vector2(646.0,-302.0)
				übergang.intro()
		)
func _döner(body: Node2D) -> void:
	area = "döner"
func _exit(body: Node2D) -> void:
	area = "none"
func _on_audio_finished() -> void:
	if endAnim:
		audioEnd = true
		$Audio.stop()
		$Audio2.play()
	else:
		$Audio.playing = true
func _on_loop() -> void:
	$Audio2.stop()
	$Schlossloop.playing = true
