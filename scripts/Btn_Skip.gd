extends Button

func _pressed():
	get_tree().get_root().get_node("Root").set_skip()
	get_tree().get_root().get_node("Root").continue_script()