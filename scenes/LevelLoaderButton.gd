extends Button


func _pressed():
	get_tree().get_root().get_node("Root").global_vars["playername"] = "Mr. Guy"
	get_tree().get_root().get_node("Root").global_vars["draconame"] = "Draco"
	get_tree().get_root().get_node("Root").setup_gender("male")
	get_tree().get_root().get_node("Root").goto_menu("LevelLoader")