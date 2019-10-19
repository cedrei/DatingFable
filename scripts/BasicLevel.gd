extends Node2D
#This is used to keep track of how far into a script we are
#Used primarily by the pause, and save/load systems
var script_step = null
var background = null
var music = null

#While we have active_sprites to be used by the global vars and writers
#the internal engine requires the list of actual sprites to use for loading purposes
var internal_active_sprites = {}

# A dict keeping track of what characters are on screen
# We need this to be able to remove them by just using their name
var active_sprites = {}

# Array to keep track of the commands list, inputted by the
# writers in .txts
var commands = []

# The data for the choice buttons
var buttons = {}

# Keep track of how many nested ifs we are in
var control_flow_layer = 0

# Keep track of which of the nester ifsa re true and false
#spelling 100
var control_flow_mask = [true]

func get_root():
	# Get the root object
	return get_tree().get_root().get_node("Root")

func count_indention(string):
	# Function to count a line's indentation level
	# Loop through the string and count the tabs
	# until a character is found that isn't a tab
	var indention_level = 0
	for letter in string:
		if letter == "	":
			indention_level += 1
		else:
			return indention_level

func set_background(name):
	get_root().global_vars["background"] = name
	# Load the image
#	var image = Image.new()
#	image.load("res://assets/backgrounds/"+name)
	
	# Make image into texture
	var texture = load("res://assets/backgrounds/"+name)
	# Set background to texture
	$Background.texture = texture
	
	# Calculate the scale to make the image fit the screen
	# Use the larger value to make sure that the background
	# fills the entire screen
	var scale = 1280.0 / texture.get_width()
	if (720.0 / texture.get_height() > scale):
		scale = 720.0 / texture.get_height()
	$Background.scale = Vector2(scale,scale)

func fade_background(percent, time):
	# Starting fade
	var current_fade = $Background.modulate
	
	# Get the animation, clear the old values
	var animation = $AnimationPlayer.get_animation("Fade Background")
	for i in range(0,animation.track_get_key_count(0)):
		animation.track_remove_key(0,i)
	
	# Set the new values
	animation.set_length(time)
	animation.track_insert_key(0, 0, current_fade)
	animation.track_insert_key(0,time, Color(percent, percent, percent, 1))
	
	# Play the animation
	$AnimationPlayer.play("Fade Background")

func enter_character(name):
	# Load the image
#	var image = Image.new()
#	image.load("res://assets/characters/"+name+"/default.png")
	
	# Make image into texture
	var texture = load("res://assets/characters/"+name+"/default.png")
	
	# Create a new sprite with the texture
	var sprite = Sprite.new()
	sprite.texture = texture
	
	# Center the image (to be changed to custom position)
	sprite.position.x = 640.0
	sprite.position.y = 360.0
	
	# Keep track of the character in the active_sprites dict
	active_sprites[name] = sprite
	internal_active_sprites[name] = "normal"
	# Add Sprite to the Characters node
	$Characters.add_child(sprite)

func change_pose(character, pose_name):
	# Load the same character but in a different pose
#	var image = Image.new()
#	image.load("res://assets/characters/"+character+"/" + pose_name + ".png")
	
	# Make the image into a texture object
	var texture = load("res://assets/characters/"+character+"/" + pose_name + ".png")
	active_sprites[character].texture = texture
	internal_active_sprites[name] = pose_name

func scale_character(character, scaleX, scaleY):
	# Set scale of character, 1 is default size, 1.5 is 50% larger
	active_sprites[character].scale.x = float(scaleX)
	active_sprites[character].scale.y = float(scaleY)

func position_character(character, posX, posY):
	# Position character on screen. 1 is all the way to the right/bottom, 0.5 is in the middle.
	active_sprites[character].position.x = float(posX) * 1280
	active_sprites[character].position.y = float(posY) * 720
	internal_active_sprites[character + "-x"] = posX
	internal_active_sprites[character + "-y"] = posY

func wait(seconds):
	# First, clear the dialogue window.
	var interface = get_root().get_text_interface()
	interface.clear()
	
	# Create a timer, set it to the inputted amount of seconds
	# Then wait for it to continue, and then execute the next command
	var t = Timer.new()
	t.set_wait_time(float(seconds))
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	# Continue the script
	# If skip is active, that can only have happened while this wait() was
	# waiting (or this function wouldn't have been called at all. Since
	# the script already continues automatically when clicking the skip button
	# this shouldn't be called if that is the case.
	if get_root().skip == 0:
		execute_next_command()

func control_flow_if(statement1, operator, statement2):
	var is_true = false
	
	# Is statement1 a number? Change type to int, if so
	if str(int(statement1)) == statement1:
		statement1 = int(statement1)
	# Is statement 1 a variable? Load its value, if so
	elif (statement1.substr(0,1) == "{"):
		statement1 = get_root().global_vars[statement1.substr(1,statement1.length()-2)]
	# Is statement2 a number? Change type to int, if so
	if str(int(statement2)) == statement2:
		statement2 = int(statement2)
	# Is statement 2 a variable? Load its value, if so
	elif statement2.substr(0,1) == "{":
		statement2 = get_root().global_vars[statement2.substr(1,statement2.length()-1)]
	
	# Use the right operator fot the comparision
	match operator:
		"<":
			is_true = statement1 < statement2
		">":
			is_true = statement1 > statement2
		"=":
			is_true = statement1 == statement2
		
	# We aer one step further into the if nesting
	control_flow_layer += 1
	# We push the current value to the top of the stack
	control_flow_mask.push_front(is_true)
	execute_next_command()

func clean_up_cutscene():
	# Remove background
	$Background.texture = null
	# Remove all characters
	for child in $Characters.get_children():
		child.queue_free()
	# Clear the dialogue window
	get_root().get_text_interface().dialogue("","")
	# Remove all character references
	active_sprites = {}
	# Clear commands list
	commands = []
	# Clear button list
	buttons = {}
	internal_active_sprites = {}

func define_button(name):
	# Make a button start existing, define placeholder values
	buttons[name] = {
		"text": "",
		"var_name": "placeholder",
		"operator": "=",
		"value": 0
	}

func set_button_text(command):
	# Set the text of a button
	# First word is just button-text
	# Convert from PoolStringArray to Array to allow for popping
	command = Array(command)
	command.pop_front()
	# Second word is the name of the button
	var name = command.pop_front()
	# Reset the text of the button
	buttons[name].text = ""
	# Loop through the rest of the words and add them to the button text
	for word in command:
		buttons[name].text += word + " "

func set_button_action(name, variable, operator, value):
	# Set what is done when button is clicked on 
	# (Only supporting setting variables, use ifs with the variables after that)
	buttons[name].var_name = variable
	buttons[name].operator = operator
	buttons[name].value = value

func show_choice(command):
	# First word is just show-choice
	# Convert from PoolStringArray to Array to allow for popping
	command = Array(command)
	command.pop_front()
	
	# Put the button data in an array
	var button_data = []
	for button_name in command:
		button_data.push_back(buttons[button_name])
	
	# Pass button array on to the interface
	get_root().get_text_interface().show_choice(button_data)

func execute_next_command():
	# Split the command into an array, word by word
	if (commands.size() == 0):
		# Reached the end of file
		# Probably should return to some menu here or whatever
		return
	var commandString = commands.pop_front()
	var command  = commandString.split(" ")
	
	
	if (command.size() == 0 or command[0] == ""):
		# Empty command, just skip this line
		execute_next_command()
		return
	
	# Check the current line's indention level
	var indention_level = count_indention(command[0])
	
	# Check for "shadow indention"
	if (command[0].length() == indention_level):
		execute_next_command()
		return
	# Remove any tabs in front of the line
	command[0] = command[0].substr(indention_level, command[0].length()-indention_level)
	
	# Is the current indention level the same as the expected? If so, no need to do anything.
	# Otherwise, we are at the end of the current control flow block
	if indention_level != control_flow_layer:
		# Remove the right amount of if nesting
		# Keep one though, we need it in case there is an else statement
# warning-ignore:unused_variable
		for i in range(0,control_flow_layer-indention_level-1):
			control_flow_mask.pop_front()
		if command[0] == "else":
			# if nesting goes up one level
			control_flow_layer = indention_level+1
			# The condition is opposite the one of the accompanying if
			control_flow_mask[0] = !control_flow_mask[0]
			execute_next_command()
			return
		else:
			# No else, remove the saved extra element in the indention stack
			control_flow_mask.pop_front()
			control_flow_layer = indention_level
	
	# If we are in a branch that shouldn't be executed, stop here and go to the next statement
	if control_flow_mask[0] == false:
		execute_next_command()
		return
	
	# Does the first word end with a ":"?
	# If so, it is a speak command
	if (command[0].substr(command[0].length()-1,1) == ":"):
		script_step = script_step + 1
		# Load a reference to the interface
		var text_interface = get_root().get_text_interface()
		
		# Get the name of the speaker
		var name = command[0]
		name = name.substr(0,name.length()-1)
		# Remove the speaker's name from the array
		command.remove(0)
		
		# Pass it on to the text_interface
		text_interface.dialogue(name, command)
		
		# Do *not* execute the next command, that is handled in the
		# ClickAnywhereToContinue script
		return
	
	if (command.size() == 1):
		# We don't want to break the following statements by not
		# not having command[1] being defined
		command.push_back("")
	
	if (command[1] == "="):
		script_step = script_step + 1
		# Set a custom variable
		# Check if it is an int
		if str(int(command[2])) == command[2]:
			# If so, convert it to an int before storing it
			get_root().global_vars[command[0]] = int(command[2])
		else:
			# Otherwise, just store it
			get_root().global_vars[command[0]] = command[2]
		execute_next_command()
		return
	
	if (command[1] == "+"):
		script_step = script_step + 1
		# Add to a custom variable
		if str(int(command[2])) == command[2]:
			# Is it an int? Just add normally. Add from 0 if the var doesn't exist
			if not get_root().global_vars.has(command[0]):
				get_root().global_vars[command[0]] = 0
			get_root().global_vars[command[0]] += int(command[2])
		else:
			# Is it a string? Do concatenation. Add from an empty string if the var doesn't exist
			if not get_root().global_vars.has(command[0]):
				get_root().global_vars[command[0]] = ""
			get_root().global_vars[command[0]] += command[2]
		execute_next_command()
		return
	
	if (command[1] == "-"):
		script_step = script_step + 1
		# Subtract from a custom variable
		if not get_root().global_vars.has(command[0]):
			get_root().global_vars[command[0]] = 0
		get_root().global_vars[command[0]] -= int(command[2])
		execute_next_command()
		return
	
	if (command[1] == "*"):
		script_step = script_step + 1
		# Multiply a custom variable
		if not get_root().global_vars.has(command[0]):
			get_root().global_vars[command[0]] = 0
		get_root().global_vars[command[0]] *= int(command[2])
		execute_next_command()
		return
	
	if (command[1] == "/"):
		script_step = script_step + 1
		# Divide a custom variable
		if not get_root().global_vars.has(command[0]):
			get_root().global_vars[command[0]] = 0
		get_root().global_vars[command[0]] /= int(command[2])
		execute_next_command()
		return
	
	# The first word is the command
	match command[0]:
		"set-bg":
			script_step = script_step + 1
			background = command[1]
			get_root().global_vars["background"] = command[1]
			set_background(command[1])
			# Remove old fades
			fade_background(1, 0)
			execute_next_command()
		"play-music":
			script_step = script_step + 1
			music = command[1]
			get_root().global_vars["music"] = command[1]
			get_root().play_music(command[1])
			execute_next_command()
		"stop-music":
			script_step = script_step + 1
			get_root().global_vars["music"] = null
			get_root().stop_music()
			execute_next_command()
		"play-sound":
			script_step = script_step + 1
			get_root().play_sound(command[1])
			execute_next_command()
		"enter":
			script_step = script_step + 1
			enter_character(command[1])
			execute_next_command()
		"exit":
			script_step = script_step + 1
			active_sprites[command[1]].queue_free()
			execute_next_command()
		"set-pose":
			script_step = script_step + 1
			change_pose(command[1], command[2])
			execute_next_command()
		"set-scale":
			script_step = script_step + 1
			scale_character(command[1], command[2], command[3])
			execute_next_command()
		"set-pos":
			script_step = script_step + 1
			position_character(command[1], command[2], command[3])
			execute_next_command()
		"pause":
			script_step = script_step + 1
			if get_root().skip == 0:
				wait(command[1])
			elif get_root().skip == 1:
				wait(0.1)
			else:
				execute_next_command()
		"load-cutscene":
			script_step = script_step + 1
			get_root().skip = 0
			clean_up_cutscene()
			init(command[1])
		"if":
			script_step = script_step + 1
			control_flow_if(command[1], command[2], command[3])
		"define-button":
			script_step = script_step + 1
			define_button(command[1])
			execute_next_command()
		"button-text":
			script_step = script_step + 1
			set_button_text(command)
			execute_next_command()
		"button-action":
			script_step = script_step + 1
			set_button_action(command[1], command[2], command[3], command[4])
			execute_next_command()
		"show-choice":
			script_step = script_step + 1
			get_root().skip = 0
			show_choice(command)
		"fade-background":
			script_step = script_step + 1
			if command.size() == 2:
				# Set default for time
				command.push_back(0)
			if command.size() == 3:
				# Set default for wait
				command.push_back("no-wait")
			fade_background(float(command[1]), float(command[2]))
			if command[3] == "wait":
				# If wait, don't do the next command until fade is done
				wait(command[2])
			else:
				execute_next_command()
		_:
			# If we still haven't figured out what to do with the line
			# there must be an error in it. Tell that to the writer.
			get_root().get_text_interface().dialogue("", "There was an error! See this line: "+commandString)

func load_txt(filename):
	# Load the file for the level
	# Save each line to an array
	var result = []
	
	# Open the file
	var f = File.new()
	f.open(filename, 1)
	
	# Loop through all the lines in the file
	while not f.eof_reached():
		var line = f.get_line()
		result.push_back(line)
	f.close()
	return result

func _ready():
	# Placeholder, will be called from outside this file
	#init("Falconreach")
	pass

#OK! this is one hell of a function but lets break it all down:
#First, we take our current script point given from execute_next_command or the save file
#Next: we take it apart and check to see if it happened to land in a "game breaking command load point"
#If so, we roll it back until its at a safe location
#Next: load the characters in specific poses and locations, while also applying the background and music
#Lastly, we set the brand new commands to be read by execute_next_command
#Logically speaking, this should be fine. Knowing me however, I messed it up somewhere somehow.
func begin_script_from_certain_point(script_point, level_name):
	var script_commands = load_txt("res://levels/" + level_name + ".txt")
	var script_point_found = false
	while (script_point_found != true):
		for i in range (0, script_commands.size()):
			if i == script_point:
				var commandCleaned = script_commands[i]
				var commandString = script_commands.pop_front()
				var commandSet  = commandString.split(" ")
				match commandSet[0]:
					"set-bg":
						script_point = script_point - 1
					"play-music":
						script_point = script_point - 1
					"stop-music":
						script_point = script_point - 1
					"play-sound":
						script_point = script_point - 1
					"enter":
						script_point = script_point - 1
					"exit":
						script_point = script_point - 1
					"set-pose":
						script_point = script_point - 1
					"set-scale":
						script_point = script_point - 1
					"set-pos":
						script_point = script_point - 1
					"pause":
						script_point = script_point - 1
					"load-cutscene":
						script_point = script_point - 1
					"if":
						script_point = script_point - 1
					"define-button":
						script_point = script_point - 1
					"button-text":
						script_point = script_point - 1
					"button-action":
						script_point = script_point - 1
					"show-choice":
						script_point = script_point - 1
					"fade-background":
						script_point = script_point - 1
					_:
						script_point_found = true
	if background == null:
		set_background(get_root().global_vars["background"])
	else:
		set_background(background)
	if music == null:
		get_root().play_music(get_root().global_vars["music"])
	else:
		get_root().play_music(music)
	#right, load sprites
	if internal_active_sprites.empty() != true:
		for i in internal_active_sprites:
			if internal_active_sprites[i] == "normal":
				enter_character(i)
				if internal_active_sprites[i + "-x"] != null:
					if internal_active_sprites[i + "-y"] != null:
						position_character(i, internal_active_sprites[i + "-x"], internal_active_sprites[i + "-y"])
			elif int(internal_active_sprites[i]) == 0:
				change_pose(i, internal_active_sprites[i])
				if internal_active_sprites[i + "-x"] != null:
					if internal_active_sprites[i + "-y"] != null:
						position_character(i, internal_active_sprites[i + "-x"], internal_active_sprites[i + "-y"])
		var counter = 0
		for i in range(script_point, script_commands.size()):
			commands[counter] = script_commands[i]
			counter = counter + 1
	else:
	#now its time to put the cleaned commands into the actual command array
	#and execute them!
		var counter = 0
		for i in range(script_point, script_commands.size()):
			commands[counter] = script_commands[i]
			counter = counter + 1
	execute_next_command()


func load_file_from_point(name, point):
	if get_tree().get_root().get_node("Root/UI/LoadGame").loadInternalSpriteData() == null:
		begin_script_from_certain_point(point, name)
	else:
		internal_active_sprites = get_tree().get_root().get_node("Root/UI/LoadGame").loadInternalSpriteData()
		begin_script_from_certain_point(point, name)

func init(level_name):
	# Load a level
	get_root().global_vars["Script"] = level_name
	script_step = 0
	commands = load_txt("res://levels/" + level_name + ".txt")
	# Loop through it's commands
	execute_next_command()