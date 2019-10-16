extends Button

func _pressed():
	get_tree().get_root().get_node("Root").global_vars["Script-Step"] = get_tree().get_root().get_node("Root/Viewport/BasicLevel").script_step
	get_tree().get_root().get_node("Root").goto_menu("Settings")