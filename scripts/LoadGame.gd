extends Control

func saveFileCheck(saveNumber):
	var fileCheck = File.new()
	if(fileCheck.file_exists("res://saves/Save" + str(saveNumber) + ".sav")):
		return true
	else:
		return false

#jesus this is a mess, clean it up if you want too ced but I'm keeping it as is
func check():
	for i in range(3):
		if(saveFileCheck(i + 1) == false):
			match i + 1:
				1: 
					$HBoxContainer/SaveOne/SOData.text = "No Save Data."
					#disable button code
					$HBoxContainer/SaveOne/SOButton.disabled = true
				2: 
					$HBoxContainer/SaveTwo/TextEdit.text = "No Save Data."
					$HBoxContainer/SaveTwo/Button.disabled = true
				3: 
					$HBoxContainer/SaveThree/TextEdit.text = "No Save Data."
					$HBoxContainer/SaveThree/Button.disabled = true
		else:
			match i + 1:
				1: 
					$HBoxContainer/SaveOne/SOData.text = "Oh hey, some data"
					$HBoxContainer/SaveOne/SOButton.disabled = true
				2: 
					$HBoxContainer/SaveTwo/TextEdit.text = "Oh hey, some data"
					$HBoxContainer/SaveTwo/Button.disabled = true
				3: 
					$HBoxContainer/SaveThree/TextEdit.text = "Oh hey, some data"
					$HBoxContainer/SaveThree/Button.disabled = true

#general structure of how this all will work:
#First, game checks if any saves exist, if not display "no save" message and disable that button.
#if there is a save, the game will display its final "snapshot" of the game and the misc data
#IE: where the player is, what time they saved the game, their name etc
#the game will also enable enable the button below it too
#Saving kinda works the same way, except no buttons are grayed out and saving will also override.
#how the saving system will work is for another day :>
#-Quartz563

func _ready():
	check()


