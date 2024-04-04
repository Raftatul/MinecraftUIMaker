extends Control

@export var background_rect: TextureRect
@export var slot_texture_rect: TextureRect

func _ready():
	add_to_group("imported_slot")
	gui_input.connect(_on_gui_input)
	
	if get_index() == 0:
		Main.instance.texture = slot_texture_rect.texture
		background_rect.visible = true

func set_slot_texture(slot_texture: Texture):
	slot_texture_rect.texture = slot_texture

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			Main.instance.texture = slot_texture_rect.texture
			get_tree().call_group("imported_slot", "set_active_state", self)

func set_active_state(slot):
	background_rect.visible = slot == self
