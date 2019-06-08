extends Button

func start_skipping(level):
	# Set skipping level and then automatically continue the script
	get_tree().get_root().get_node("Root").set_skip(level)
	get_tree().get_root().get_node("Root").continue_script()

func _pressed():
	# Press the button, set skipping mode to 1 (fast forward)
	start_skipping(1)

func _process(delta):
	if Input.is_action_just_pressed("Instant Skip"):
		# Press Ctrl+tab, and skip instantly to the next choice or cutscene
		start_skipping(2)
	elif Input.is_action_just_pressed("Skip"):
		# Press only tab, and fast forward
		start_skipping(1)