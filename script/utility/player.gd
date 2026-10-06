extends CharacterBody2D

@onready var anim = $Spiti

# 50 normal
const moveSpeed = 50.0
var dir = 'd'
var canMove = true

func _physics_process(delta: float) -> void:
	if !Utils.input: return
	
	var input = Vector2.ZERO
	
	# Extrem langes if statement das irgendwie funktioniert aber weiß nicht wie :) is aber egal
	if canMove:
		if Input.is_action_pressed("Up"):
			input.y -= 1
			dir = 'u'
			anim.play("WalkUp")
			anim.flip_h = false
		elif Input.is_action_pressed("Down"):
			input.y += 1
			dir = 'd'
			anim.play("WalkDown")
			anim.flip_h = false
		elif Input.is_action_pressed("Left"):
			input.x -= 1
			dir = 'l'
			anim.play("WalkSide")
			anim.flip_h = true
		elif Input.is_action_pressed("Right"):
			input.x += 1
			dir = 'r'
			anim.play("WalkSide")
			anim.flip_h = false
		elif dir == 'u':
			anim.play("IdleUp")
		elif dir == 'd':
			anim.play("IdleDown")
		elif dir == 'l':
			anim.play("IdleSide")
		elif dir == 'r':
			anim.play("IdleSide")
	else:
		if dir == 'u':
			anim.play("IdleUp")
		elif dir == 'd':
			anim.play("IdleDown")
		elif dir == 'l':
			anim.play("IdleSide")
		elif dir == 'r':
			anim.play("IdleSide")
	
	velocity = input * moveSpeed
	
	move_and_slide()
