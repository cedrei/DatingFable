extends Node

# Vars accessible from the cutscene editor
var global_vars = {
	"man": "woman",
	"Man": "Woman",
	"he": "she",
	"He": "She",
	"Stud": "Lady",
	"stud": "lady",
	"handsome": "gorgeous",
	"Handsome": "Gorgeous",
	"masculine": "feminine",
	"Masculine": "Feminine",
	"Muscular": "Womanly",
	"muscular": "womanly"
}

func hide_menus():
	# Hide all UI
	for node in $UI.get_children():
		node.visible = false

func goto_menu(name):
	# Hide all UI
	hide_menus()
	# Hide the viewport
	$Viewport.visible = false
	# Show the right menu
	match name:
		"title":
			$UI.TitleScreen.visible = true
		"level-loader":
			$UI.LevelLoader.visible = true

func show_interface():
	# Hide all UI
	hide_menus()
	# Show the in-game interface
	$UI/TextInterface.visible = true

func get_text_interface():
	# Get a reference to the in-game interface
	return $UI/TextInterface

func _ready():
	# Start the game in a level, placeholder testing code.
	show_interface()
	$Viewport.visible = true

func continue_script():
	# Execute the next command in the cutscene editor
	$Viewport/BasicLevel.execute_next_command()