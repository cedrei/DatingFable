extends TextureButton

func _ready():
	# Create click mask
	# Load the image to a variable
	var image = Image.new()
	image.load("res://assets/buttons_titlescreen/settings.png")
	# Convert image to bitmap
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	# Set clickmask to bitmap
	texture_click_mask = bitmap