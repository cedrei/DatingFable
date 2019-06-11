extends Button

# Placeholder values
var action = {
	"variable": "myVar",
	"operator": "=",
	"value": 0
}

func _pressed():
	# Tell the TextInterface that a button was clicked
	# Also, what the data for that button was
	get_parent().get_parent().get_parent().button_pressed(text, action)