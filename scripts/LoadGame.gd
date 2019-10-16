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
					$HBoxContainer/LoadOne/LOData.text = "No Save Data."
					$HBoxContainer/LoadOne/LOButton.disabled = true
				2: 
					$HBoxContainer/LoadTwo/LTWData.text = "No Save Data."
					$HBoxContainer/LoadTwo/LTWButton.disabled = true
				3: 
					$HBoxContainer/LoadThree/LTHData.text = "No Save Data."
					$HBoxContainer/LoadThree/LTHButton.disabled = true
		else:
			match i + 1:
				1: 
					$HBoxContainer/LoadOne/LOData.text = "Oh hey, some data"
					$HBoxContainer/LoadOne/LOButton.disabled = false
				2: 
					$HBoxContainer/LoadTwo/LTWData.text = "Oh hey, some data"
					$HBoxContainer/LoadTwo/LTWButton.disabled = false
				3: 
					$HBoxContainer/LoadThree/LTHData.text = "Oh hey, some data"
					$HBoxContainer/LoadThree/LTHButton.disabled = false

#general structure of how this all will work:
#First, game checks if any saves exist, if not display "no save" message and disable that button.
#if there is a save, the game will display its final "snapshot" of the game and the misc data
#IE: where the player is, what time they saved the game, their name etc
#the game will also enable enable the button below it too
#Saving kinda works the same way, except no buttons are grayed out and saving will also override.
#how the saving system will work is for another day :>
#-Quartz563

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game(saveNumber):
	var new_data = {}
	var save_game = File.new()
	if not saveFileCheck(saveNumber):
		return # Error! We don't have a save to load.
    # Load the file line by line and process that dictionary to restore
    # the object it represents.
	save_game.open("res://saves/Save" + str(saveNumber) + ".sav", File.READ)
	var current_data = parse_json(save_game.get_as_text())
	new_data = current_data
	save_game.close()
	loadGlobalVars(new_data)
	getGlobalVars(new_data)
	get_tree().get_root().get_node("Root").get_node("Viewport").get_node("BasicLevel").load_file_from_point(new_data["Script"], new_data["Script-Point"])

func loadGlobalVars(data):
	get_tree().get_root().get_node("Root").global_vars = data

func getGlobalVars(globalVar):
	globalVar = get_tree().get_root().get_node("Root").global_vars
	return globalVar

func _ready():
	check()


