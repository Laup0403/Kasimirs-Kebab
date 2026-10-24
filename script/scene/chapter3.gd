extends Node2D

@onready var player = $Objects/Player
@onready var textbox = $UI/Textbox
@onready var roomCam = $Room/Camera2D
var oldX = 0
var intro = false
var introplaying = false
var area = "none"
var room = "none"
var timer = 0
var back = false
var speaken = [false, false, false, false]

func _ready() -> void:
	if not Utils.piepmatz.playing: Utils.piepmatz.playing = true
	
	$Room/Player.canMove = false
	player.dir = 'u'
	if not back:
		$Map/Stein.play()
		if oldX != 0:
			player.position.x = oldX + 432
		textbox.addText("Klaus", "Oh shit the wall collapsed\nbehind me")
	else:
		speaken[0] = true
		speaken[1] = true
		speaken[2] = true
		speaken[3] = true
		$Objects/Gitter/CollisionShape2D.disabled = true
		$Objects/Gitter/AnimatedSprite2D.frame = 5
		if oldX != 0:
			player.position = Vector2(oldX,-640.0)

func _process(delta: float) -> void:
	var normCam = player.get_node("Camera2D")
	var roomPlayer = $Room/Player
	var wiseman = $Room/Wiseman
	
	## Intro
	if not intro && player.position.y <= -200.0:
		introplaying = true
		player.canMove = false
		var camera = $Objects/Player/Camera2D
		if camera.global_position.x != 0:
			camera.global_position.x = move_toward(camera.global_position.x, 0, 5)
		if camera.zoom != Vector2(3.0, 3.0):
			camera.zoom -= Vector2(0.25, 0.25)
		if camera.global_position.y >= -310.0:
			camera.position.y -= 1
		else:
			if Input.is_anything_pressed():
				introplaying = false
				intro = true
				camera.zoom = Vector2(12.0, 12.0)
				camera.position = Vector2(0.0, 0.0)
				player.canMove = true
	
	## In den räumen
	if roomCam.enabled:
		if not $"Map/DönermanTheme".playing:
			Utils.piepmatz.stop()
			$"Map/DönermanTheme".playing = true
		if room == "exit" && roomPlayer.dir == 'd':
			roomCam.enabled = false
			normCam.enabled = true
			player.canMove = true
			roomPlayer.canMove = false
			player.dir = 'd'
			room = "none"
			$"Map/DönermanTheme".stop()
			Utils.piepmatz.playing = true

		# B) Mit Wiseman reden
		elif room == "man" && roomPlayer.dir == 'u' && Input.is_action_just_pressed("Action1") && textbox.state == "ready":
			roomPlayer.canMove = false
			if area == "1":
				textbox.addText("Wiseman 1", "A long time ago\n(like 30 minutes)\nKasimir was very hungry.", func():roomPlayer.canMove = true; speaken[0] = true)
			elif area == "2":
				textbox.addText("Wiseman 2", "He searched around and \nfound a kebab skewer.", func():roomPlayer.canMove = true; speaken[1] = true)
			elif area == "3":
				textbox.addText("Wiseman 3", "He had no money, so\nhe just stole the\nkebab skewer (lol).", func():roomPlayer.canMove = true; speaken[2] = true)
			elif area == "4":
				textbox.addText("Wiseman 4", "Kasimirs lives in the castle,\nbtw.")
				textbox.addText("Wiseman 4", "Just in case you want\nto visit him.", func():roomPlayer.canMove = true; speaken[3] = true)
	
	else:
		if (area == "1" and player.dir == 'l') or (area == "2" and player.dir == 'u') or (area == "3" and player.dir == 'u') or (area == "4" and player.dir == 'r'):
			roomCam.enabled = true
			normCam.enabled = false
			player.canMove = false
			roomPlayer.canMove = true
			roomPlayer.dir = 'u'
			roomPlayer.position = Vector2(616.0, -384.0)
			wiseman.frame = area.to_int() - 1
	
	## Gatter öffnen ##
	if speaken.all(func(v): return v) && not roomCam.enabled && not $Objects/Gitter/CollisionShape2D.disabled:
		player.canMove = false
		$Objects/Player/Camera2D.enabled = false
		$FenceCamera.enabled = true
		var gitter = $Objects/Gitter/AnimatedSprite2D
		if gitter.frame != 5:
			gitter.play()
		else:
			$Objects/Gitter/CollisionShape2D.disabled = true
			player.canMove = true
			$Objects/Player/Camera2D.enabled = true
			$FenceCamera.enabled = false
	
	## Scene switchen
	if player.position.y <= -641.0:
		var nextRes = load("res://scenes/chapter4.tscn")
		var next = nextRes.instantiate()
		next.spawn = Vector2(player.position.x,113.0)
		get_tree().root.add_child(next)
		queue_free()

func _exited(body: Node2D) -> void:
	if body == player: area = "none"
func _1_entered(body: Node2D) -> void:
	if body == player: area = "1"
func _2_entered(body: Node2D) -> void:
	if body == player: area = "2"
func _3_entered(body: Node2D) -> void:
	if body == player: area = "3"
func _4_entered(body: Node2D) -> void:
	if body == player: area = "4"

func _room_exit_entered(body: Node2D) -> void:
	if body == $Room/Player: room = "exit"
func _room_exited(body: Node2D) -> void:
	if body == $Room/Player: room = "none"
func _room_man_entered(body: Node2D) -> void:
	if body == $Room/Player: room = "man"
