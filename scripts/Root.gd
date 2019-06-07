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
var skip = false

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
	var audiostream = load('res://assets/audio/music/' + name + '.ogg')
	$Audio/Music.set_stream(audiostream)
	$Audio/Music.play()

func play_sound(name):
	# Create new AudioStreamPlayer
	var audio_stream_player = AudioStreamPlayer.new()
	
	# Load the sound, and set the AudioStreamPlayer to play it
	var audiostream = load('res://assets/audio/sounds/' + name + '.wav')
	audio_stream_player.set_stream(audiostream)
	audio_stream_player.volume_db = -12.0
	
	# Add the node to the tree
	$Audio.add_child(audio_stream_player)
	# Play the sound
	audio_stream_player.play()
	# Wait for sound to finish
	yield(audio_stream_player, "finished")
	# Clear up the node to prevent memory leak
	$Audio.remove_child(audio_stream_player)
	audio_stream_player.queue_free()

func stop_music():
	# Stop the current music
	$Audio/Music.stop()

func continue_script():
	# Execute the next command in the cutscene editor
	$Viewport/BasicLevel.execute_next_command()

func set_skip():
	skip = true

func play_game():
	# Start new game from title screen
	show_interface()
	$Viewport.visible = true
	$Viewport/BasicLevel.init("introduction")