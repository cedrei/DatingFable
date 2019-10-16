extends Button

func getGlobalVars():
	return get_tree().get_root().get_node("Root").global_vars

func _pressed():
	var global_data = getGlobalVars()
	get_tree().get_root().get_node("Root").get_node("Viewport").get_node("BasicLevel").load_file_from_point(global_data["Script"], global_data["Script-Step"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
