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
	
	# Under this is WIP for now
	var scale = ($SpeakerImage.margin_right - $SpeakerImage.margin_left) / image.get_width()
	if (($SpeakerImage.margin_bottom - $SpeakerImage.margin_top) / image.get_height() > scale):
		scale = ($SpeakerImage.margin_bottom - $SpeakerImage.margin_top) / image.get_height() / image.get_height()
	
	$SpeakerImage/Picture.texture = texture
	
	var image_center_x = ($SpeakerImage.margin_right + $SpeakerImage.margin_left)/2
	var image_center_y = ($SpeakerImage.margin_bottom + $SpeakerImage.margin_top)/2
	
	$SpeakerImage/Picture.margin_top = image_center_y - scale*image.get_height()/2
	$SpeakerImage/Picture.margin_bottom = image_center_y + scale*image.get_height()/2
	$SpeakerImage/Picture.margin_left = image_center_x - scale*image.get_width()/2
	$SpeakerImage/Picture.margin_right = image_center_x + scale*image.get_width()/2

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

func continue_script():
	# Player has finished reading, next command!
	get_tree().get_root().get_node("Root").continue_script()