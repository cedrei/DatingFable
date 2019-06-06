extends TextureButton

#var image = preload("res://assets/buttons_titlescreen/play_game.png")

func _pressed():
	# goto charcreation
	get_tree().get_root().get_node("Root").goto_menu("char-creation")

func _ready():
	# Create click mask
	# Load the image to a variable
	var image = Image.new()
	image.load("res://assets/buttons_titlescreen/play_game.png")
	# Convert image to bitmap
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	# Set clickmask to bitmap
	texture_click_mask = bitmap