extends Node2D

@onready var player = $Objects/Player
@onready var textbox = $UI/Textbox

var area = "none"
var msmauer = 0
var angry = 0

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
						textbox.addText("Ms. Mauer", "If you want to get in...\nTHEN SHOW ME YOUR\nSKILLS!", func(): get_tree().quit()),
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
						textbox.addText("Ms. Mauer", "If you want to get in...\nTHEN SHOW ME YOUR\nSKILLS!", func(): get_tree().quit()),
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
	else:
		$Objects/Player/Camera2D.zoom = Vector2(12.0,12.0)

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
