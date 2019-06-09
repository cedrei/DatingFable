extends TextureButton

func _ready():
	# Create click mask
	# Load the image to a variable
	var image = Image.new()
	image.load("res://assets/buttons_titlescreen/load_game.png")
	# Convert image to bitmap
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	# Set clickmask to bitmap
	texture_click_mask = bitmap

func _pressed():
	# Temporary stuff, use this button to load the level loader
	get_tree().get_root().get_node("Root").global_vars["playername"] = "Mr. Guy"
	get_tree().get_root().get_node("Root").global_vars["draconame"] = "Draco"
	get_tree().get_root().get_node("Root").setup_gender("male")
	
	get_tree().get_root().get_node("Root").goto_menu("level-loader")