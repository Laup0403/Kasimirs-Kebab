extends Node2D

@onready var player = $Objects/Player
@onready var textbox = $UI/Textbox
var oldX = 0

func _ready() -> void:
	player.dir = 'u'
	if oldX != 0:
		player.position.x = oldX + 432
	textbox.addText("Klaus", "Oh shit the wall collapsed\nbehind me")

# x1 -278.0
# x2 154.0
# + 432

func _process(delta: float) -> void:
	pass
