extends Node

@export var selected_idex := 0
@export var panel_container: Control

var categories := []

func _ready():
	for child in get_children():
		categories.append(child)
		child.selected.connect(_on_category_selected)
		
	categories[selected_idex].select()
	panel_container.get_child(selected_idex).visible = true

func _on_category_selected(category: Category):
	for i in categories:
		i.deselect()
		panel_container.get_child(categories.find(i)).visible = false
	
	category.select()
	panel_container.get_child(categories.find(category)).visible = true
