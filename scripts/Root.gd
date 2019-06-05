extends Node

# Values of the gender pronouns automatically loaded into the game at gender pickinh
var gender_pronouns = [
	["man", "woman"],
	["Man", "Woman"],
	["he", "she"],
	["He", "She"],
	["Stud", "Lady"],
	["stud", "lady"],
	["handsome", "gorgeous"],
	["Handsome", "Gorgeous"],
	["masculine", "feminine"],
	["Masculine", "Feminine"],
	["Muscular", "Womanly"],
	["muscular", "womanly"],
	["him", "her"],
	["his", "her"],
	["Him", "Her"],
	["His", "Her"],
	["Himself", "Herself"],
	["himself", "herself"]
]

# Vars accessible from the cutscene editor
var global_vars = {}

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
		"char-creation":
			$UI/CharCreation.visible = true

func show_interface():
	# Hide all UI
	hide_menus()
	# Show the in-game interface
	$UI/TextInterface.visible = true

func get_text_interface():
	# Get a reference to the in-game interface
	return $UI/TextInterface

func _ready():
	pass
	# Start the game in a level, placeholder testing code.
	#show_interface()
	#$Viewport.visible = true

func setup_gender(gender):
	# Set all appropriate gender pronouns
	var gender_id
	if gender == "female":
		gender_id = 1
	else:
		gender_id = 0
	global_vars["gender"] = gender
	# Loop through the gender_prounouns. Set the masculine form as the key, and then
	# the appropriate version as the value
	for i in range(0,gender_pronouns.size()):
		global_vars[gender_pronouns[i][0]] = gender_pronouns[i][gender_id]

func play_music(name):
	# Set the stream of the Music node to the inputted music
	var audiostream = load('res://audio/' + name + '.ogg')
	$Audio/Music.set_stream(audiostream)
	$Audio/Music.play()

func continue_script():
	# Execute the next command in the cutscene editor
	$Viewport/BasicLevel.execute_next_command()

func play_game():
	# Start new game from title screen
	show_interface()
	$Viewport.visible = true
	$Viewport/BasicLevel.init("introduction")