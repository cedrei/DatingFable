extends Control

var globalVar = get_tree().get_root().getNode("Root").global_vars
var textBoxesChanged = false
var gender = null

#checks if any of the text boxes are left empty
func checkTextBoxes():
	if not $HeroName/HBoxContainer/HeroName.text.empty():
		if not $DracoName/HBoxContainer/DracoName.text.empty():
			textBoxesChanged = true

#checks what gender is selected
func checkGender():
	if $GenderSelect/VBoxContainer/HBoxContainer/check_Female.is_pressed():
		gender = "female"
	elif $GenderSelect/VBoxContainer/HBoxContainer/check_Male.is_pressed():
		gender = "male"
	else:
		gender = null

#stores everything in global vars
func _pressed():
	checkTextBoxes()
	checkGender()
	if textBoxesChanged == true:
		globalVar.Name = $HeroName/HBoxContainer/HeroName.text
		globalVar.DracoName = $DracoName/HBoxContainer/DracoName.text
	if not gender == null:
		globalVar.Gender = gender