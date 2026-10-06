extends CanvasLayer

@onready var übergang = $"Übergang"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	übergang.visible = false

func outro(afterCall: Callable = Callable()):
	Utils.disableInput()
	übergang.visible = true
	übergang.play("default")
	await übergang.animation_finished
	übergang.visible = false
	if afterCall: afterCall.call()
	Utils.enableInput()

func intro(afterCall: Callable  = Callable()):
	Utils.disableInput()
	übergang.visible = true
	übergang.play_backwards("default")
	await übergang.animation_finished
	übergang.visible = false
	if afterCall: afterCall.call()
	Utils.enableInput()
