extends CanvasLayer

var state = "invisible"
var index = 0
var timer = 0
var TextboxVisible = false
var textQueue = []
var entry

@onready var label = $Text
@onready var textname = $Name
@onready var checker = $Checker
@onready var sprite = $Sprite2D

@export var player = CharacterBody2D

func _ready() -> void:
	hideTextbox()

func hideTextbox():
	TextboxVisible = false
	sprite.hide()
	checker.hide()
	label.text = ""
	textname.text = ""
	state = "ready"
	player.canMove = true

func showTextbox():
	TextboxVisible = true
	sprite.show()
	player.canMove = false

func addText(name:String,text:String,afterCall:Callable=Callable()):
	textQueue.push_back({
		"name": name,
		"text": text,
		"afterCall": afterCall
	})

func addQuestion(name:String,text:String,ifYes:Callable,ifNo:Callable):
	textQueue.push_back({
		"name": name,
		"text": text,
		"ifYes": ifYes,
		"ifNo": ifNo,
	})

func clear():
	textQueue = []

func showNextText():
	entry = textQueue.pop_front()
	textname.text = ">"+entry.name
	label.text = entry.text
	label.visible_characters = 0
	timer = 0
	showTextbox()
	index = 0
	state = "reading"

func _process(delta: float) -> void:
	
	if state == "ready" && !textQueue.is_empty():
		showTextbox()
		showNextText()
		state == "reading"
		return
	elif state == "ready" && textQueue.is_empty():
		if sprite.visible:
			hideTextbox()
	
	if index < len(label.text) && state == "reading":
		
		if timer <= 0:
			var currentChar = label.text[index]
			
			if currentChar == "." || currentChar == "!" || currentChar == "?":
				timer = 0.25
			elif currentChar == ",":
				timer = 0.08
			else:
				timer = 0.01
			
			index += 1
		else:
			timer -= delta
		
		label.visible_characters = index
	
	elif index >= len(label.text) && state == "reading":
		state = "finished"
		label.visible_characters = -1
		checker.show()
	
	if state == "reading" && Input.is_action_just_pressed("Action1"):
		index = len(label.text)
	
	if state == "finished" && entry.has("ifYes") && entry.has("ifNo"):
		if Input.is_action_just_pressed("Action1"):
			entry.ifYes.call()
			state = "ready"
			checker.hide()
		elif Input.is_action_just_pressed("Action2"):
			entry.ifNo.call()
			state = "ready"
			checker.hide()
	
	elif state == "finished" && Input.is_action_just_pressed("Action1"):
		if entry.afterCall:
			entry.afterCall.call()
		state = "ready"
		checker.hide()
