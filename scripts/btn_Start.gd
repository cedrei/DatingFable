extends TextureButton

func _pressed():
	get_tree().get_root().get_node("Root").play_game()