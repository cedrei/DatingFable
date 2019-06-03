extends TextureButton

var is_listening = false

func _pressed():
	if (is_listening):
		is_listening = false
		get_parent().continue_script()