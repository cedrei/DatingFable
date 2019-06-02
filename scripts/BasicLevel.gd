extends Node2D

func set_background(name):
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
	var scale = 1440.0 / image.get_width()
	if (720.0 / image.get_height() > scale):
		scale = 720.0 / image.get_height()
	$Background.scale = Vector2(scale,scale)

func execute(command):
	# Split the command into an array
	command = command.split(" ")
	
	# The first word is the command
	if (command[0] == "set-bg"):
		set_background(command[1])

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
	var commands = load_txt("res://levels/" + level_name + ".txt")
	# Loop through it's commands
	for command in commands:
		execute(command)