extends TextureButton

func _pressed():
	# goto charcreation
	get_tree().get_root().get_node("Root").goto_menu("char-creation")