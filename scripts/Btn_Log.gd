extends Button

func _pressed():
	get_tree().get_root().get_node("Root").show_log()