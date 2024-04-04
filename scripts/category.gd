extends TextureRect
class_name Category

signal selected(category: Category)

@export var selected_texture: Texture
@export var unselected_texture: Texture

func _ready():
	gui_input.connect(on_gui_input)

func on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			selected.emit(self)

func select():
	texture = selected_texture

func deselect():
	texture = unselected_texture
