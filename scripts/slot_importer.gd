extends Node

static var slot_save_path := "user://slots/"

@export_file("*.tscn") var imported_slot_scene

@export var slot_container: Container
@export var import_btn: Button

func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("slots")
	
	for file in DirAccess.get_files_at(slot_save_path):
		_on_file_selected(slot_save_path + file)
	
	import_btn.pressed.connect(_on_import_btn_pressed)

func _on_import_btn_pressed():
	
	var dialog := FileDialog.new()
	
	dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	dialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	
	dialog.set_use_native_dialog(true)
	dialog.dialog_hide_on_ok = true
	
	dialog.add_filter("*.png", "Texture")
	
	dialog.file_selected.connect(_on_file_selected)
	dialog.file_selected.connect(save_texture)
	
	dialog.popup()

func save_texture(path: String):
	var img := Image.load_from_file(path)
	if img != null:
		img.save_png(slot_save_path + path.get_slice("\\", path.get_slice_count("\\") - 1))

func _on_file_selected(path: String):
	var img := Image.load_from_file(path)
	if img != null:
		instantiate_slot(ImageTexture.create_from_image(img))
	else:
		print("Error: Could not parse project file")

func instantiate_slot(texture: Texture):
	var scene_instance = load(imported_slot_scene)
	var slot_instance = scene_instance.instantiate()
	
	slot_instance.set_slot_texture(texture)
	slot_container.add_child(slot_instance)
