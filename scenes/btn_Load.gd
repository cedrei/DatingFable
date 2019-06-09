extends TextureButton

func _pressed():
	# Temporary stuff, use this button to load the level loader
	get_tree().get_root().get_node("Root").global_vars["playername"] = "Mr. Guy"
	get_tree().get_root().get_node("Root").global_vars["draconame"] = "Draco"
	get_tree().get_root().get_node("Root").setup_gender("male")
	
	get_tree().get_root().get_node("Root").goto_menu("level-loader")