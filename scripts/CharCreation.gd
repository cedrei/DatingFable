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


#stores everything in global vars
func _pressed():
	checkTextBoxes()
	checkGender()
	globalVars = getGlobalVars(globalVars)
	if textBoxesChanged == true:
		globalVars["playername"] = $HeroName/HBoxContainer/HeroName.text
		globalVars["draconame"] = $DracoName/HBoxContainer/DracoName.text
	if not gender == null:
		globalVars.Gender = gender
	#Starts up the game
	get_tree().get_root().get_node("Root").play_game()