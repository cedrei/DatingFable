extends Control
var globalVars = null
var saveFileNumber = null


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
					$HBoxContainer/SaveOne/SOData.text = "No Save Data.\nOpen for a new Save"
				2: 
					$HBoxContainer/SaveTwo/STWData.text = "No Save Data.\nOpen for a new Save"
				3: 
					$HBoxContainer/SaveThree/STHData.text = "No Save Data.\nOpen for a new Save"
		else:
			match i + 1:
				1: 
					$HBoxContainer/SaveOne/SOData.text = "Oh hey, some data"
				2: 
					$HBoxContainer/SaveTwo/STWData.text = "Oh hey, some data"
				3: 
					$HBoxContainer/SaveThree/STHData.text = "Oh hey, some data"

#my god I hate this god damn popup system so much.
#it wont even summon anymore? like w h a t?
#I'll remove these messages once I get it working, but until then, well we are stuck like this.

func getSave(saveNumber):
	saveFileNumber = saveNumber
	if(saveFileCheck(saveNumber) == true):
		get_node("ConfirmationDialog").summon()
		if(_on_ConfirmationDialog_confirmed() == true):
			saveGame(saveNumber)
	else:
		saveGame(saveNumber)

# warning-ignore:unused_argument
func getGlobalVars(globalVar):
	globalVar = get_tree().get_root().get_node("Root").global_vars
	return globalVar

#hopefully this should save the game 
func saveGame(saveNumber):
	var data = getGlobalVars(globalVars)
	var file = File.new()
	if file.open("res://saves/Save" + str(saveNumber) + ".sav", File.WRITE) != 0:
    	print("Error opening file")
    	return
	file.store_line(to_json(data))
	file.close()
	check()

func _ready():
	check()

func _on_ConfirmationDialog_confirmed():
	return true 
