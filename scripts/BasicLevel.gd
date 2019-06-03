extends Node2D

# A dict keeping track of what characters are on screen
# We need this to be able to remove them by just using their name
var active_sprites = {}

# Array to keep track of the commands list, inputted by the
# writers in .txts
var commands = []

func set_background(name):
	print("Set bg "+name)
	# Load the image
	var image = Image.new()
	image.load("res://assets/backgrounds/"+name)
	
	# Make image into texture
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	# Set background to texture
	$Background.texture = texture
	
	# Calculate the scale to make the image fit the screen
	# Use the larger value to make sure that the background
	# fills the entire screen
	var scale = 1280.0 / image.get_width()
	if (720.0 / image.get_height() > scale):
		scale = 720.0 / image.get_height()
	$Background.scale = Vector2(scale,scale)

func enter_character(name):
	# Load the image
	var image = Image.new()
	image.load("res://assets/characters/"+name+"/default.png")
	
	# Make image into texture
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	# Create a new sprite with the texture
	var sprite = Sprite.new()
	sprite.texture = texture
	
	# Center the image (to be changed to custom position)
	sprite.position.x = 640.0
	sprite.position.y = 360.0
	
	# Keep track of the character in the active_sprites dict
	active_sprites[name] = sprite
	
	# Add Sprite to the Characters node
	$Characters.add_child(sprite)

func change_pose(character, name):
	# Load the same character but in a different pose
	var image = Image.new()
	image.load("res://assets/characters/"+character+"/" + name + ".png")
	
	# Make the image into a texture object
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	active_sprites[character].texture = texture

func wait(seconds):
	# Create a timer, set it to the inputted amount of seconds
	# Then wait for it to continue, and then execute the next command
	var t = Timer.new()
	t.set_wait_time(int(seconds))
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	execute_next_command()

func execute_next_command():
	# Split the command into an array, word by word
	var command = commands.pop_front().split(" ")
	
	# Does the first word end with a ":"?
	# If so, it is a speak command
	if (command[0].substr(command[0].length()-1,1) == ":"):
		# Load a reference to the interface
		var text_interface = get_tree().get_root().get_node("Root").get_text_interface()
		
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
	
	if (command[1] == "="):
		# Set a custom variable
		# Check if it is an int
		if str(int(command[2])) == command[2]:
			# If so, convert it to an int before storing it
			get_tree().get_root().get_node("Root").global_vars[command[0]] = int(command[2])
		else:
			# Otherwise, just store it
			get_tree().get_root().get_node("Root").global_vars[command[0]] = command[2]
		execute_next_command()
		return
	
	if (command[1] == "+"):
		# Add to a custom variable
		if str(int(command[2])) == command[2]:
			# Is it an int? Just add normally. Add from 0 if the var doesn't exist
			if not get_tree().get_root().get_node("Root").global_vars.has(command[0]):
				get_tree().get_root().get_node("Root").global_vars[command[0]] = 0
			get_tree().get_root().get_node("Root").global_vars[command[0]] += int(command[2])
		else:
			# Is it a string? Do concatenation. Add from an empty string if the var doesn't exist
			if not get_tree().get_root().get_node("Root").global_vars.has(command[0]):
				get_tree().get_root().get_node("Root").global_vars[command[0]] = ""
			get_tree().get_root().get_node("Root").global_vars[command[0]] += command[2]
		execute_next_command()
		return
	
	if (command[1] == "-"):
		# Subtract from a custom variable
		if not get_tree().get_root().get_node("Root").global_vars.has(command[0]):
			get_tree().get_root().get_node("Root").global_vars[command[0]] = 0
		get_tree().get_root().get_node("Root").global_vars[command[0]] -= int(command[2])
		execute_next_command()
		return
	
	if (command[1] == "*"):
		# Multiply a custom variable
		if not get_tree().get_root().get_node("Root").global_vars.has(command[0]):
			get_tree().get_root().get_node("Root").global_vars[command[0]] = 0
		get_tree().get_root().get_node("Root").global_vars[command[0]] *= int(command[2])
		execute_next_command()
		return
	
	if (command[1] == "/"):
		# Divide a custom variable
		if not get_tree().get_root().get_node("Root").global_vars.has(command[0]):
			get_tree().get_root().get_node("Root").global_vars[command[0]] = 0
		get_tree().get_root().get_node("Root").global_vars[command[0]] /= int(command[2])
		execute_next_command()
		return
	
	# The first word is the command
	match command[0]:
		"set-bg":
			set_background(command[1])
			execute_next_command()
		"enter":
			enter_character(command[1])
			execute_next_command()
		"set-pose":
			change_pose(command[1], command[2])
			execute_next_command()
		"pause":
			wait(command[1])
		

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
	init("Falconreach")

func init(level_name):
	# Load a level
	commands = load_txt("res://levels/" + level_name + ".txt")
	# Loop through it's commands
	execute_next_command()