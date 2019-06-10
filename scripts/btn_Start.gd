extends TextureButton

#var image = preload("res://assets/buttons_titlescreen/play_game.png")

func _pressed():
	# goto charcreation
	get_tree().get_root().get_node("Root").goto_menu("CharCreation")