extends Node
class_name Slot

const MAX_X := 158
const MAX_Y := 148

@export var index_label: Label
@export var delete_button: TextureRect

@export var x_input: LineEdit
@export var y_input: LineEdit

var index: int
var main: Main
var slot: Control

@onready var LineEditRegEx := RegEx.new()

func _enter_tree():
	delete_button.gui_input.connect(delete_button_gui_input)
	
	x_input.text_changed.connect(set_slot_x)
	y_input.text_changed.connect(set_slot_Y)
	
	x_input.focus_entered.connect(x_input.select_all)
	y_input.focus_entered.connect(y_input.select_all)

func set_index(index: int):
	self.index = index
	index_label.text = str(index)

func delete_button_gui_input(event: InputEvent):
	if not event.is_pressed():
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			main.remove_slot(index)

func set_slot_x(value: String):
	if not x_input.text.is_valid_int():
		x_input.text = remove_no_int(value)
		x_input.caret_column = value.length()
		
	slot.position.x = clamp(int(value), 0, MAX_X)

func set_slot_Y(value):
	if not y_input.text.is_valid_int():
		y_input.text = remove_no_int(value)
		y_input.caret_column = value.length()
		
	slot.position.y = clamp(int(value), 0, MAX_Y)

func remove_no_int(value: String) -> String:
	for i in range(value.length() - 1):
		if not value[i].is_valid_int():
			value = value.erase(i)
			i -= 1
	return value

func get_position() -> Vector2:
	return slot.position + Vector2.ONE
