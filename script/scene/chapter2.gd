extends Node2D

@onready var player = $Objects/Player
@onready var textbox = $UI/Textbox
@onready var übergang = $"UI/Übergang"

var area = "none"
var msmauer = 0
var angry = 0
var fightState = 0
var timer = 0
var beamState = 0

func _ready() -> void:
	übergang.intro()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if area == "msmauer":
		if msmauer == 0:
			player.canMove = false
		
			var camera = player.get_node("Camera2D")
			camera.zoom = Vector2(5.0,5.0)
			if camera.position.x + player.position.x < -490.0 or camera.position.x + player.position.x > -488.0:
				if camera.position.x + player.global_position.x > -489.0:
					camera.position.x -= 1.0
				elif camera.position.x + player.global_position.x < -489.0:
					camera.position.x += 1.0
			elif camera.position.y + player.global_position.y > -282.0:
				camera.position.y -= 1.0
			else:
				msmauer = 1
				textbox.addQuestion("Ms. Mauer", "Do you wan't to enter\nthe valley?\n    Yes("+Utils.getKey("Action1")+") No("+Utils.getKey("Action2")+")",
					func():
						textbox.addText("Ms. Mauer", "It's not easy in there, yk?")
						textbox.addText("Ms. Mauer", "If you want to get in...\nTHEN SHOW ME YOUR\nSKILLS!", func(): fightState = 1),
					func():
						textbox.addText("Ms. Mauer", "Then go away!\nThis isn't a playground!", 
							func(): 
								camera.position = Vector2(0.0,0.0)
								msmauer = 2
						)
				)
		elif msmauer == 2:
			$Objects/Player/Camera2D.zoom = Vector2(5.0,5.0)
			if Input.is_action_just_pressed("Action1") and player.dir == 'u' && textbox.state == "ready":
				textbox.addQuestion("Ms. Mauer", "Did you change your mind?\n    Yes("+Utils.getKey("Action1")+") No("+Utils.getKey("Action2")+")",
					func():
						textbox.addText("Ms. Mauer", "It's not easy in there, yk?")
						textbox.addText("Ms. Mauer", "If you want to get in...\nTHEN SHOW ME YOUR\nSKILLS!", func(): fightState = 1),
					func():
						angry += 1
						if angry == 1:
							textbox.addText("Ms. Mauer", "THEN GO AWAY!")
						if angry == 2:
							textbox.addText("Ms. Mauer", "really?")
						if angry == 3:
							textbox.addText("Ms. Mauer", "do you think you are\nfunny?")
						if angry == 4:
							textbox.addText("Ms. Mauer", "ENOUGH!", func(): msmauer = 3)
				)
		elif msmauer == 3:
			player.canMove = false
			var rock = $"Objects/Player/SüßliSteinli"
			rock.visible = true
			if rock.position.y <= 0:
				rock.position.y += 8
			elif Input.is_anything_pressed():
				get_tree().reload_current_scene()
		elif msmauer == 6:
			$Objects/Player/Camera2D.zoom = Vector2(5.0,5.0)
			if Input.is_action_just_pressed("Action1") and textbox.state == "ready":
				textbox.addText("Ms. Mauer", "What?")
	else:
		$Objects/Player/Camera2D.zoom = Vector2(12.0,12.0)
	
	if area == "ausgang":
		#get_tree().change_scene_to_file("res://scenes/chapter3.tscn")
		var newRes = load("res://scenes/chapter3.tscn")
		var new = newRes.instantiate()
		new.oldX = player.position.x
		get_tree().root.add_child(new)
		queue_free()
	
	if fightState != 0: fightProcess(delta)

func fightProcess(delta):
	if fightState == 1:
		player.canMove = false
		var spookyman = $UI/Spookyman
		if spookyman.position.x != 0: spookyman.position.x -= 10
		elif textbox.textQueue.is_empty(): 
			$UI/Black.visible = true
			textbox.addText("???", "Yo, wassup")
			textbox.addText("???", "I'm the Spookyman.")
			textbox.addText("Spookyman", "Normally, you should'nt\nmeet me")
			textbox.addText("Spookyman","but we don't want\nto tolerate violence.")
			textbox.addQuestion("Spookyman","If you want, you can\ndo this puzzle instead\nSure("+Utils.getKey("Action1")+") No thanks("+Utils.getKey("Action2")+")",
				func():
					textbox.clear()
					textbox.addText("Spookyman", "ok good luck!\nor bad luck! (if you\ndon't like good luck)", func(): fightState = 2; textbox.clear()),
				func():
					textbox.clear()
					textbox.addText("Spookyman", "You don't want to do\nmy puzzle?")
					textbox.addText("Spookyman", "That doesn't sound like\nmy problem! ;)", func(): fightState = 2; textbox.clear())
			)
		else:
			return
	elif fightState == 2:
		get_tree().change_scene_to_file("res://scenes/puzzle.tscn")
	elif fightState == 3:
		$Objects/Player/Camera2D.zoom = Vector2(5.0,5.0)
		player.position = Vector2(-488.0,-222.0)
		player.dir = 'u'
		player.canMove = false
		
		var hans = $Objects/Hans
		hans.visible =  true
		if hans.position.y <= -50.0:
			hans.position.y += 3.0
			hans.get_node("AnimatedSprite2D").rotation += 0.3
		else:
			msmauer = 6
			var hanssprite = hans.get_node("AnimatedSprite2D")
			hanssprite.rotation = 0
			hanssprite.play("default")
			fightState = 4
			player.canMove = true
	elif fightState == 4:
		if area == "hans" and textbox.state == "ready" and Input.is_action_just_pressed("Action1"):
			textbox.addText("Hans", "YO KLAUS!", func(): $UI/DingsBums.visible = true)
			textbox.addText("Hans", "I found some cool thing\nand wanted to test it\nwith you!", func(): $Objects/EpicCamera.enabled = true; player.get_node("Camera2D").enabled = false; $UI/DingsBums.visible = false)
			textbox.addText("Hans", "What do you think\ndoes that button do?", func(): fightState = 5) 
	elif fightState == 5:
		$Objects/Hans/AnimatedSprite2D.animation = "back"
		var beam = $Objects/Beam
		if beamState == 0:
			beam.visible = true
			Utils.disableInput()
			beamState = 1
			timer = 4
		else:
			if timer <= 0:
				if beamState == 1:
					beam.scale = Vector2(0.493,0.024)
					timer = 3
					beamState = 2
				elif beamState == 2:
					beam.scale = Vector2(0.643,0.954)
					timer = 5
					beamState = 3
				elif beamState == 3:
					beam.visible = false
					
					$Map/Walls/CollisionShape2D4.disabled = true
					$Map/GroundDestroyed.enabled = true
					$Map/BlumsDestroyed.enabled = true
					$Map/MsMauer/CollisionShape2D.disabled = true
					$Map/Walls/AfterMsMauer.disabled = false
					$Map/Walls/AfterMsMauer2.disabled = false
					
					timer = 2
					beamState = 4
				elif beamState == 4:
					Utils.enableInput()
					textbox.addText("Hans","Lol", func(): $Objects/EpicCamera.enabled = false; $Objects/Player/Camera2D.enabled = true; $Objects/Hans/AnimatedSprite2D.play("default"); textbox.addText("Hans","That was fun!"))
					beamState = 5
					fightState = 6
					return
			timer -= delta
		
		if beamState >= 1 and beamState < 5:
			var shake_strength = 2.0
			var random_offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
			if beamState == 1:
				beam.position = Vector2(-418.0,-101.309) + random_offset
			elif beamState == 2:
				beam.position = Vector2(-418.0, -267.499) + random_offset
			elif beamState == 3:
				beam.position = Vector2(-418.0, -321.296) + random_offset

func _any_exited(body: Node2D) -> void:
	if body == player:
		area = "none"

func _ms_mauer_entered(body: Node2D) -> void:
	if body == player:
		area = "msmauer"
func _on_exit_entered(body: Node2D) -> void:
	if body == player:
		player.position.x = $Map/KeinAusgang/CollisionShape2D.position.x - 17
		textbox.addText("Laupi", "Sorry, but you can't\ngo there.\nGreetings - Laupi")
func _hans_entered(body: Node2D) -> void:
	if body == player:
		area = "hans"
func _ausgang_entered(body: Node2D) -> void:
	if body == player:
		area = "ausgang"
		print("ausgang")
