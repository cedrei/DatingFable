extends TextureButton

# Variable to keep track of whether we're
# waiting for a click
var is_listening = false

func _pressed():
	if (is_listening):
		if get_parent().printing:
			get_parent().get_node("TextDisplay/TextEdit").write_all()
		else:
			is_listening = false
			get_parent().continue_script()