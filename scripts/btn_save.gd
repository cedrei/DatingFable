extends Button

func _pressed():
	#todo: get background, get characters, get cutscene(file name), get line pos and save them into global vars.
	#these will be used when creating the save file to "pick up" where we left off.
	#extra validation will be required to make it all work. 
	get_tree().get_root().get_node("Root").goto_menu("SaveGame")

