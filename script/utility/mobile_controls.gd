extends CanvasLayer

@export var textbox: CanvasLayer
@export var chapter: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Arrows.visible = false
	$Question.visible = false
	$Textbox.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Utils.input or not Utils.mobile:
		$Arrows.visible = false
		$Question.visible = false
		$Textbox.visible = false
		return
	
	if chapter != null:
		if chapter.name == "Main" and (chapter.coolAnimation != 0 or chapter.hansstate == 9 or chapter.hansstate == 7 or chapter.hansstate == 6):
			$Arrows.visible = false
			$Question.visible = false
			$Textbox.visible = true
		elif chapter.name == "chapter2" and (chapter.msmauer == 3 or (chapter.msmauer == 0 and chapter.area == "msmauer") or chapter.fightState >= 1):
			$Arrows.visible = false
			$Question.visible = false
			$Textbox.visible = true
			return
		elif chapter.name == "chapter3" and (chapter.introplaying or (chapter.speaken.all(func(v): return v) && not chapter.roomCam.enabled && not chapter.get_node("Objects/Gitter/CollisionShape2D").disabled)):
			$Arrows.visible = false
			$Question.visible = false
			$Textbox.visible = true
			return
		elif chapter.name == "chapter5" and (chapter.get_node("MainRoom/Wallbottom/Gatter").is_playing() or chapter.endAnim):
			$Arrows.visible = false
			$Question.visible = false
			$Textbox.visible = true
			return

	if textbox == null or textbox.state == "ready" && textbox.textQueue == []:
		$Arrows.visible = true
		$Question.visible = false
		$Textbox.visible = false
	elif textbox.state == "finished" && textbox.entry.has("ifYes") && textbox.entry.has("ifNo"):
		$Arrows.visible = false
		$Question.visible = true
		$Textbox.visible = false
	else:
		$Arrows.visible = false
		$Question.visible = false
		$Textbox.visible = true
