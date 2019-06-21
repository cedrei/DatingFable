extends Control

var printing = false
var dialogue_parts = []

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
			if (get_tree().get_root().get_node("Root").global_vars.has(variable_name)):
				# Does the var exist? Add it to the thing then.
				final_word += str(get_tree().get_root().get_node("Root").global_vars[variable_name])
			else:
				# Variable doesn't exist. Make a warning.
				final_word += "WARNING! Variable {"+variable_name+"} is not defined."
		elif is_in_variable:
			# We are reading a variable name
			variable_name += letter
		else:
			# We are reading normal letters
			final_word += letter
	return final_word

func load_speaker_image(name):
	# Load the speaker image file
#	var image = Image.new()
#	image.load("res://assets/characters/"+name+"/speaker_image.png")
	
	var file_path = "res://assets/characters/"+name+"/speaker_image.png"
	
	var directory = Directory.new()
	if not directory.file_exists(file_path):
		return
	
	# Make image into texture
	var texture = load(file_path)
	
	# Add the texture to the picture
	$SpeakerImage/Picture.texture = texture

func dialogue(name, dialogue):
	# Make some dialogue
	$TextDisplay/TextEdit.text = ""
	# We are now waiting for the player to click
	# Get the speaker's image to the speaker thingy
	load_speaker_image(name)
	
	
	var string = ""
	# Loop through the string and print it to the text box, after replacing the variables in them
	for word in dialogue:
		word = replace_variables(word)
		string += word + " "
	
	dialogue_parts = string.split("|")
	
	
	print_line(dialogue_parts[0])

func print_line(dialogue_part):
	dialogue_parts.remove(0)
	
	# Save to the dialogue log
	get_root().dialogue_log.push_back([name, dialogue_part])
	
	printing = true
	$TextDisplay/TextEdit.print_dialogue(dialogue_part)
	
	if get_root().skip == 1:
		wait(0.1)
	elif get_root().skip == 2:
		continue_script()
	else:
		$ClickAnywhereToContinue.is_listening = true

func show_choice(button_data):
	# Swap the text display to a button display
	$TextDisplay/TextEdit.visible = false
	$TextDisplay/ButtonContainer.visible = true
	var current_button_id = 1
	for button in button_data:
		# Get the right button
		var current_button = $TextDisplay/ButtonContainer.get_node("Button"+str(current_button_id))
		# Show it
		current_button.visible = true
		# Set text and action from button_data
		current_button.text = button.text
		current_button.action = {
			"variable": button.var_name,
			"operator": button.operator,
			"value": button.value
		}
		# Next button has an id higher
		current_button_id += 1

func get_root():
	return get_tree().get_root().get_node("Root")

func wait(seconds):
	# Create a timer, set it to the inputted amount of seconds
	# Then wait for it to continue, and then execute the next command
	var t = Timer.new()
	t.set_wait_time(float(seconds))
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	continue_script()

func button_pressed(text, action):
	# One of the choice buttons are clicked!
	# Hide buttons, show text display
	$TextDisplay/TextEdit.visible = true
	$TextDisplay/ButtonContainer.visible = false
	
	# Save to the dialogue log
	get_root().dialogue_log.push_back(["Picked option", text])
	# All buttons need to be individually hidden too
	# Otherwise, if the next button choice has less options than
	# this one, the remaining buttons would still be there
	for button in $TextDisplay/ButtonContainer.get_children():
		button.visible = false
	match action.operator:
		"=":
			# Set a custom variable
			# Check if it is an int
			if str(int(action.value)) == action.value:
				# If so, convert it to an int before storing it
				get_root().global_vars[action.variable] = int(action.value)
			else:
				# Otherwise, just store it
				get_root().global_vars[action.variable] = action.value
		"+":
			# Add to a custom variable
			if str(int(action.value)) == action.value:
				# Is it an int? Just add normally. Add from 0 if the var doesn't exist
				if not get_root().global_vars.has(action.variable):
					get_root().global_vars[action.variable] = 0
				get_root().global_vars[action.variable] += int(action.value)
			else:
				# Is it a string? Do concatenation. Add from an empty string if the var doesn't exist
				if not get_root().global_vars.has(action.variable):
					get_root().global_vars[action.variable] = ""
				get_root().global_vars[action.variable] += action.value
		"-":
			# Subtract from a custom variable
			if not get_root().global_vars.has(action.variable):
				get_root().global_vars[action.variable] = 0
			get_root().global_vars[action.variable] -= int(action.value)
		"*":
			# Multiply a custom variable
			if not get_root().global_vars.has(action.variable):
				get_root().global_vars[action.variable] = 0
			get_root().global_vars[action.variable] *= int(action.value)
		"/":
			# Divide a custom variable
			if not get_root().global_vars.has(action.variable):
				get_root().global_vars[action.variable] = 0
			get_root().global_vars[action.variable] /= int(action.value)
	get_root().continue_script()

func clear():
	# Clear the dialogue window
	$TextDisplay/TextEdit.text = ""
	$SpeakerImage/Picture.texture = null

func continue_script():
	if dialogue_parts.size() > 0:
		print_line(dialogue_parts[0])
	else:
		# Player has finished reading, next command!
		get_root().continue_script()