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

#this function forces only one gender to be selected at any given time.
func forceSingularGender():
	if $GenderSelect/VBoxContainer/HBoxContainer/check_Male.checked():
		$GenderSelect/VBoxContainer/HBoxContainer/check_Male.unchecked()
	if $GenderSelect/VBoxContainer/HBoxContainer/check_Female.checked():
		$GenderSelect/VBoxContainer/HBoxContainer/check_Female.unchecked()


#stores everything in global vars
func continue_pressed():
	checkTextBoxes()
	checkGender()
	globalVars = getGlobalVars(globalVars)
	if textBoxesChanged == true:
		globalVars["playername"] = $HeroName/HBoxContainer/HeroName.text
		globalVars["draconame"] = $DracoName/HBoxContainer/DracoName.text
	if not gender == null:
		globalVars["gender"] = gender
	#Starts up the game
	get_tree().get_root().get_node("Root").play_game()