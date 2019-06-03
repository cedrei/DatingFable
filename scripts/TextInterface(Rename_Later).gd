extends Control

func replace_variables(word):
	# Replace the variables (inside {}) with their values
	# The output
	var final_word = ""
	# If the loop is currently reading a variable name
	var is_in_variable = false
	# The name of the variable it is currently reading
	var variable_name = ""
	for letter in word:
		if letter == "{":
			# Start of a variable
			is_in_variable = true
			variable_name = ""
		elif letter == "}":
			# End of a variable, add it's value to the final_word
			is_in_variable = false
			final_word += str(get_tree().get_root().get_node("Root").global_vars[variable_name])
		elif is_in_variable:
			# We are reading a variable name
			variable_name += letter
		else:
			# We are reading normal letters
			final_word += letter
	return final_word

func load_speaker_image(name):
	# Load the speaker image file
	var image = Image.new()
	image.load("res://assets/characters/"+name+"/speaker_image.png")
	
	# Make image into texture
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	# Add the texture to the picture
	$SpeakerImage/Picture.texture = texture

func dialogue(name, dialogue):
	# Make some dialogue
	$TextDisplay/TextEdit.text = ""
	# We are now waiting for the player to click
	$ClickAnywhereToContinue.is_listening = true
	# Get the speaker's image to the speaker thingy
	load_speaker_image(name)
	# Loop through the string and print it to the text box, after replacing the variables in them
	for word in dialogue:
		word = replace_variables(word)
		$TextDisplay/TextEdit.text += word + " "

func clear():
	# Clear the dialogue window
	$TextDisplay/TextEdit.text = ""
	$SpeakerImage/Picture.texture = null

func continue_script():
	# Player has finished reading, next command!
	get_tree().get_root().get_node("Root").continue_script()