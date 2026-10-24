extends Node2D

@onready var player = $Objects/Player
@onready var textbox = $UI/Textbox
@onready var cam = $Objects/Player/Camera2D
var area = "none"
var spawn: Vector2
var is_changing_scene = false


func _ready() -> void:
	if not Utils.piepmatz.playing: Utils.piepmatz.playing = true
	$Objects/Chillguy/AnimatedSprite2D.play("idle")
	if not spawn: player.position = Vector2(0.0,113.0)
	else: player.position = spawn

func _process(delta: float) -> void:
	if player.position.y > 113.0:
		var nextRes = load("res://scenes/chapter3.tscn")
		var next = nextRes.instantiate()
		next.back = true
		next.oldX = player.position.x
		get_tree().root.add_child(next)
		queue_free()
	
	if area == "chillguy" and player.dir == 'u' and textbox.state == "ready" and Input.is_action_just_pressed("Action1"):
		$Objects/Chillguy/Chillguy.playing=true
		textbox.addText("Chillguy", "Yo, wassup?")
		textbox.addText("Klaus", "I'm searching a castle \nwhere some Kasimir lives in.\nDid you see one?")
		textbox.addText("Chillguy", "Yeah, I think\n it is in the north.")
		textbox.addText("Klaus", "Ok, thanks!", func():$Objects/Chillguy/Chillguy.playing=false)

func _stadt_exit(body: Node2D) -> void:
	cam.zoom = Vector2(12.0,12.0)
func _stadt_entered(body: Node2D) -> void:
	cam.zoom = Vector2(6.0,6.0)
func _chillguy(body: Node2D) -> void:
	if body == player: area = "chillguy"
func _exited(body: Node2D) -> void:
	if body == player: area = "none"
func _castle(body: Node2D) -> void:
	if body == player and not is_changing_scene:
		is_changing_scene = true
		$"UI/Übergang".outro(func():
			var nextRes = load("res://scenes/chapter5.tscn")
			var next = nextRes.instantiate()
			get_tree().root.add_child(next)
			queue_free()
		)
