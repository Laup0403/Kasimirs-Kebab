extends CanvasLayer

@onready var console = $MarginContainer/Text

var playerHealth = 100
var enemyHealth = 100
var selected = 0
var menu = "Main"
var moves = {
	"Actions": [
		{
			"name": "<--"
		},
		{
			"name": "Attack",
			"damage": 10,
		},
		{
			"name": "Feed",
			"damage": -10,
		}
	],
	"Specials": [
		{
			"name": "<--"
		}
	],
	"Items": [
		{
			"name": "<--"
		}
	]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	console.text = ""

func _process(delta: float) -> void:
	if visible:
		
		# Print
		
		var path = "~|"
		var displayMoves = ""
		var maxSelected = -1
		
		if menu == "Main":
			
			var categories = moves.keys()
			
			for i in range(categories.size()):
				var move = categories[i]
				maxSelected += 1
				
				if i == selected:
					displayMoves = displayMoves + "$ | " + move + "\n"
				else:
					displayMoves = displayMoves + "  | " + move + "\n"
		elif menu != "Main":
			path = path + menu + "|"
			for i in range(moves[menu].size()):
				var move = moves[menu][i]
				maxSelected += 1
				
				if i == selected:
					displayMoves = displayMoves + "$ | " + move.name + "\n"
				else:
					displayMoves = displayMoves + "  | " + move.name + "\n"
		
		console.text = "Klaus: "+str(playerHealth)+"%\n
						Enemy:"+str(enemyHealth)+"%\n
						" + path + "\n" + displayMoves
		
		# Input
		
		if Input.is_action_just_pressed("Down"):
			if selected == maxSelected:
				selected = 0
			else:
				selected += 1
		elif Input.is_action_just_pressed("Up"):
			if selected == 0:
				selected = maxSelected
			else:
				selected -= 1
		elif Input.is_action_just_pressed("Action1"):
			if menu == "Main":
				var categories = moves.keys()
				
				for i in range(categories.size()):
					var move = categories[i]
					
					if selected == 0:
						menu = "Actions"
						selected = 0
						break
					elif selected == 1:
						menu = "Specials"
						selected = 0
						break
					elif selected == 2:
						menu = "Items"
						selected = 0
						break
			else:
				for i in range(moves[menu].size()):
					var move = moves[menu][i]
					
					if menu == "Actions":
						if selected == 0: # Back
							menu = "Main"
							break
						elif selected == i:
							enemyHealth -= move.damage
							break
					elif menu == "Specials":
						if selected == 0:
							menu = "Main"
							break
					elif menu == "Items":
						if selected == 0:
							menu = "Main"
							break
