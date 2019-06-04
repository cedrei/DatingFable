extends TextureButton

func _pressed():
	# Start a new game.
	get_tree().get_root().get_node("Root").play_game()