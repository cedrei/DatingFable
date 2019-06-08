extends Control

var globalVars = null
var textBoxesChanged = false
var gender = null

#checks if any of the text boxes are left empty
func checkTextBoxes():
	if not $HeroName/HBoxContainer/HeroName.text == null:
		if not $DracoName/HBoxContainer/DracoName.text == null:
			textBoxesChanged = true

#checks what gender is selected
func checkGender():
	if $GenderSelect/VBoxContainer/HBoxContainer/check_Female.is_pressed():
		gender = "female"
	elif $GenderSelect/VBoxContainer/HBoxContainer/check_Male.is_pressed():
		gender = "male"
	else:
		gender = null

func getGlobalVars(globalVar):
	globalVar = get_tree().get_root().get_node("Root").global_vars
	return globalVar

func try_unlocking_continue_button():
	# If all values are set to something, unlock the continue button
	# Otherwise, lock it
	var is_hero_name_value_set = $HeroName/HBoxContainer/HeroName.text != ""
	var is_draco_name_value_set = $DracoName/HBoxContainer/DracoName.text != ""
	var is_male_check_value_set = $GenderSelect/VBoxContainer/HBoxContainer/check_Male.pressed
	var is_female_check_value_set = $GenderSelect/VBoxContainer/HBoxContainer/check_Female.pressed
	
	if is_hero_name_value_set and is_draco_name_value_set and (is_male_check_value_set or is_female_check_value_set):
		$btn_continue.disabled = false
	else:
		$btn_continue.disabled = true

#this function forces only one gender to be selected at any given time.
func forceSingularGender(gender):
	if gender == "male" and $GenderSelect/VBoxContainer/HBoxContainer/check_Female.pressed:
		$GenderSelect/VBoxContainer/HBoxContainer/check_Female.pressed = false
	if gender == "female" and $GenderSelect/VBoxContainer/HBoxContainer/check_Male.pressed:
		$GenderSelect/VBoxContainer/HBoxContainer/check_Male.pressed = false


#stores everything in global vars
func continue_pressed():
	checkTextBoxes()
	checkGender()
	globalVars = getGlobalVars(globalVars)
	if textBoxesChanged == true:
		globalVars["playername"] = $HeroName/HBoxContainer/HeroName.text
		globalVars["draconame"] = $DracoName/HBoxContainer/DracoName.text
	if not gender == null:
		# Sets up all gender pronoun variables
		get_tree().get_root().get_node("Root").setup_gender(gender)
	#Starts up the game
	get_tree().get_root().get_node("Root").play_game()

func _on_check_Female_toggled(button_pressed):
	if button_pressed:
		forceSingularGender("female")
	try_unlocking_continue_button()

func _on_check_Male_toggled(button_pressed):
	if button_pressed:
		forceSingularGender("male")
	try_unlocking_continue_button()


func _on_HeroName_text_changed():
	try_unlocking_continue_button()


func _on_DracoName_text_changed():
	try_unlocking_continue_button()