extends Node
class_name Main

static var instance: Main
static var save_path := "user://screenshots/"

@export var texture: Texture

@export var slots_container: Control
@export var slot_inputs_container: Control

@export var add_button: Button
@export var export_background_button: Button
@export var copy_java_button: Button

@export var viewPort: SubViewport

const SLOT = preload("res://scenes/slot.tscn")

var slots: Array[Control] = []
var slots_input: Array[Slot] = []

func _enter_tree():
	add_button.pressed.connect(add_slot)
	export_background_button.pressed.connect(export_background)
	copy_java_button.pressed.connect(copy_java_code)
	
	instance = self

func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")

func _input(event):
	if event.is_action("take_screen"):
		var img := get_viewport().get_texture().get_image()
		img.save_png(save_path + str(Time.get_time_dict_from_system().second) + ".png")

func refresh_ui():
	for i in range(slots_input.size()):
		slots_input[i].set_index(i)

func add_slot():
	var slot_input = SLOT.instantiate()
	slot_input.main = self
	
	slot_inputs_container.add_child(slot_input)
	slot_input.set_index(slot_inputs_container.get_child_count() - 1)
	
	var rect = TextureRect.new()
	rect.texture = texture
	rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.custom_minimum_size = Vector2(18, 18)
	rect.reset_size()
	slots_container.add_child(rect)
	
	slot_input.slot = rect
	
	slots.append(rect)
	slots_input.append(slot_input)

func remove_slot(index: int):
	slots[index].queue_free()
	slots_input[index].queue_free()
	
	slots.remove_at(index)
	slots_input.remove_at(index)
	
	call_deferred("refresh_ui")


func export_background():
	var img := viewPort.get_texture().get_image()
	
	var test := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	for x in img.get_size().x:
		for y in img.get_size().y:
			test.set_pixel(x, y, img.get_pixel(x, y))
			
	test.save_png(save_path + "background.png")

func copy_java_code():
	var output := ""
	
	for i in slots_input:
		var x := i.get_position().x
		var y :=  i.get_position().y
		
		output += "this.addSlot(new Slot(entityInventory, " + str(i.index) + ", " + str(x) + ", " + str(y) + "));\n"
	
	DisplayServer.clipboard_set(output)
