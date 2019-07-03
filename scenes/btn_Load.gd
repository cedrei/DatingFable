extends TextureButton

func _pressed():
	##yes, I know its the level loading screen, I will change it later.
	get_tree().get_root().get_node("Root").goto_menu("SaveGame")