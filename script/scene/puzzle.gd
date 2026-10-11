extends Node2D

@onready var player = $Player
@onready var tilemap = $Wall
@onready var plates = $"Plates"
@onready var übergang = $"Übergang"

func _ready() -> void:
	$Label.text = "press "+Utils.getKey("Action1")+" to restart"

func _process(delta: float) -> void:
	
	## Movement
	
	if Input.is_action_just_pressed("Up"):
		movePlayer(0,-8)
	elif Input.is_action_just_pressed("Down"):
		movePlayer(0,8)
	elif Input.is_action_just_pressed("Left"):
		movePlayer(-8,0)
	elif Input.is_action_just_pressed("Right"):
		movePlayer(8,0)
	elif Input.is_action_just_pressed("Action1") or Input.is_action_just_pressed("Action2"):
		get_tree().reload_current_scene()
		return

func movePlayer(x,y):
	var dir = Vector2(x,y)
	var target = player.position + dir
	
	## Get Box
	var pushed = null
	for pushable in get_tree().get_nodes_in_group("Pushable"):
		if pushable.position == target:
			pushed = pushable
	
	## Move Box if no wall
	if pushed:
		var pushedTarget = target + dir
		if not checkWall(pushedTarget):
			pushed.position += dir
			player.position += dir
	
	## Move Player if not wall
	else:
		if not checkWall(target):
			player.position += dir
	
	if winCondition():
		var winRes = load("res://scenes/chapter2.tscn")
		var win = winRes.instantiate()
		win.fightState = 3
		win.msmauer = 5
		übergang.outro(
		func():
			get_tree().root.add_child(win)
			queue_free()
		)

func checkWall(pos):
	var cell_pos = tilemap.local_to_map(tilemap.to_local(pos))
	if tilemap.get_cell_source_id(cell_pos) != -1:
		return true
	if getPushable(pos) != null:
		return true
	return false

func getPushable(pos: Vector2) -> Node2D:
	for kiste in get_tree().get_nodes_in_group("Pushable"):
		if kiste.global_position.round() == pos.round():
			return
	return null

func winCondition() -> bool:
	var used_cells = plates.get_used_cells()
	
	if used_cells.is_empty():
		return false

	for cell in used_cells:
		var world_pos = plates.to_global(plates.map_to_local(cell))
		
		var found = false
		for kiste in get_tree().get_nodes_in_group("Pushable"):
			if kiste.global_position.round() == world_pos.round():
				found = true
				break
		
		if not found:
			return false
	
	return true
