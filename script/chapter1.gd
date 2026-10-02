extends Node2D

@onready var hans = $Objects/Hans
@onready var player = $Objects/Player
@onready var textbox = $Textbox
@onready var übergang = $"UI/Übergang"

var area = "none"
var dönispoken = false
var hansstate = 0
var coolAnimation = 0
var preMonster = false
var monster = false
var exit = false

func _ready() -> void:
	übergang.intro()

func _process(delta: float) -> void:
	
	if !Utils.input: return
	
	## random hans calls ##
	if hansstate == 4: hans.get_node("AnimatedSprite2D").play("back")
	elif hansstate != 3: hans.get_node("AnimatedSprite2D").play("default")
	if coolAnimation != 0:
		var anim = $UI/CollAnimation
		player.canMove = false
		anim.visible = true
		if Input.is_action_just_pressed("Action1"):
			if coolAnimation == 1:
				anim.play()
				coolAnimation = 2
			elif !anim.is_playing() and coolAnimation == 2:
				anim.visible = false
				player.canMove = true
				coolAnimation = 0
				textbox.addText("Hans", "Today a new kebab shop \nhas opened in town.")
				textbox.addText("Hans", "You MUST try it.\nGo east to the \nkebab shop.")
	elif hansstate == 3:
		var anim = hans.get_node("AnimatedSprite2D")
		if anim.position.y >= -70:
			anim.play("flydaychinatowm")
			anim.position.y -= 0.8
			player.canMove = false
		else:
			player.canMove = true
			hansstate = 4
			hans.global_position.y -= 310
			hans.global_position.x -= 4
			anim.position.x = 0
			anim.position.y = 0
			hans.get_node("Area1/Coll1").disabled = true
			hans.get_node("Area1/Coll2").disabled = false
			area = "none"
	elif hansstate == 4:
		if area == "hans":
			textbox.addText("Hans", "Look at that amazing view!", func(): hansstate = 5)
			textbox.addText("Hans","I have an Idea!")
			textbox.addText("Hans","Let's race!\nWhoever finds the kebab\nskewer first wins!", func(): hansstate = 6; textbox.clear())
	elif hansstate == 6:
		var anim = hans.get_node("AnimatedSprite2D")
		player.canMove = false
		anim.play("flydaychinatowm")
		hans.get_node("Area1/Coll2").disabled = true
		hans.get_node("Coll1").disabled = true
		if hans.position.y >= -360.0:
			hans.position.y -= 0.5
			hans.rotation += 0.1
		else:
			hansstate = 7
	elif hansstate == 7:
		var camera = $Objects/IntroCamera
		camera.enabled = true
		player.get_node("Camera2D").enabled = false
		$Map/Waterfall.play("default")
		if camera.position.y != -806.0:
			camera.position.y -= 1
		elif Input.is_anything_pressed():
			player.canMove = true
			camera.enabled = false
			player.get_node("Camera2D").enabled = true
			hansstate = 8
	
	## Monster ##
	elif preMonster:
		textbox.addText("???", "Turn around or\nthe tickle monster comes")
		preMonster = false
	elif monster:
		player.canMove = false
		hansstate = 8
		textbox.clear()
		monster = false
		textbox.addText("???", "I warned you!", func(): $UI/Monster.visible = true; hansstate = 9; return)
	elif hansstate == 9:
		if Input.is_action_just_pressed("Action1"):
			get_tree().reload_current_scene()
	
	## Exit ##
	elif exit or (area == "exit" and Input.is_action_just_pressed("Action1") and textbox.state == "ready"):
		textbox.addQuestion(
			"Laupi", 
			"You are going to enter the\nvalley. Are you sure?\n    Yes("+Utils.getKey("Action1")+") No("+Utils.getKey("Action2")+")",
			func(): übergang.outro(func(): get_tree().change_scene_to_file("res://scenes/chapter2.tscn")),
			func(): return
		)
		exit = false
	
	## Check Area ##
	elif Input.is_action_just_pressed("Action1") and textbox.state == "ready":
		if area == "hans" and player.dir == 'u':
			if hansstate == 0:
				textbox.addText("Hans", "Yo Klaus!", func(): coolAnimation = 1)
				hansstate = 1
			elif hansstate == 1:
				textbox.addText("Hans", "What are you waiting for?")
			elif hansstate == 2:
				textbox.addText("Klaus", "The kebab skewer was\nstolen by a bettle!")
				textbox.addText("Hans", "Oh, no!\nWe're did that beetle go?")
				textbox.addText("Klaus", "The Doner guy said\nhe went to the valley.")
				textbox.addText("Hans", "We must find this beetle!\nLet's go after him!", func(): hansstate = 3)
		elif area == "döner" and player.dir == "u":
			if !dönispoken :
				textbox.addQuestion(
				"Doner guy", 
				"Do you want\na doner kebab?\nYes("+Utils.getKey("Action1")+") No("+Utils.getKey("Action2")+")", 
				func():
					hansstate = 2
					dönispoken = true 
					textbox.addText("Doner guy", "Sorry but my kebab skewer\nwas stolen by some beetle\nwith a red cape")
					textbox.addText("Doner guy", "Can you help me\nget it back, please?")
					textbox.addText("Doner guy", "The beetle went towards \nthe valley."), 
				func(): 
					textbox.addText("Doner guy", "Ok")
				)
			else:
				textbox.addText("Doner guy", "Please, get back my\nkebab skewer. You'll get a\ndoner kebab for free!")
		elif area == "sign" and player.dir == "u":
			textbox.addText("Sign", "< a tuff house\n\\ valley\n> kebab shop")

func _any_exited(body: Node2D) -> void:
	if body == $Objects/Player: area = "none"

func _hans_entered(body: Node2D) -> void:
	if body == $Objects/Player: area = "hans"
func _döner_entered(body: Node2D) -> void:
	if body == $Objects/Player: area = "döner"
func _sign_entered(body: Node2D) -> void:
	if body == $Objects/Player: area = "sign"

func _pre_monster_entered(body: Node2D) -> void:
	if body == $Objects/Player: preMonster = true
func _monster_entered(body: Node2D) -> void:
	if body == $Objects/Player: monster = true

func _exit_entered(body: Node2D) -> void: 
	if body == $Objects/Player:
		exit = true
		area = "exit"
