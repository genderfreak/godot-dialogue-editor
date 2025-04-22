extends Control

@onready var file_menu_options = [
	["Save", _save_pressed],
	["Load", _load_pressed],
	["Export", func(): pass],
]

@export var add_node_menu: MenuButton

@export var graph_edit: GraphEdit

var right_clicked = false

func _ready():
	for i in file_menu_options:
		%FileMenu.get_popup().add_item(i[0])
	%FileMenu.get_popup().id_pressed.connect(func (idx: int):file_menu_options[idx][1].call())
	assert(add_node_menu)
	for i in DialogueEditorSettings.node_types:
		add_node_menu.get_popup().add_item(i)
	add_node_menu.get_popup().id_pressed.connect(_add_node_pressed)
	graph_edit.right_clicked.connect(_graph_edit_right_clicked)

func _create_file_popup() -> FileDialog:
	var popup = FileDialog.new()
	popup.add_filter("*.json; Dialogue System File")
	popup.access = FileDialog.ACCESS_FILESYSTEM
	popup.show_hidden_files=true
	popup.use_native_dialog=true
	return popup

func _save_pressed():
	var popup = _create_file_popup()
	add_child(popup)
	popup.popup_centered_ratio()
	popup.file_selected.connect(graph_edit.save_to_file)
	
func _load_pressed():
	var popup = _create_file_popup()
	popup.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	add_child(popup)
	popup.popup_centered_ratio()
	popup.file_selected.connect(graph_edit.load_from_file)

func _graph_edit_right_clicked():
	right_clicked=true
	var popup = add_node_menu.get_popup()
	popup.position=get_global_mouse_position()
	popup.size=Vector2(0,0)
	popup.popup()
	get_viewport().set_input_as_handled()

func _add_node_pressed(idx):
	var key = add_node_menu.get_popup().get_item_text(idx)
	var instance: BaseNode = DialogueEditorSettings.node_types[key].instantiate()
	graph_edit.add_child(instance)
	instance.change_name(instance.name)
	if right_clicked:
		instance.position_offset = (graph_edit.get_local_mouse_position() + graph_edit.scroll_offset) / graph_edit.zoom
	else:
		instance.position_offset = graph_edit.scroll_offset + (graph_edit.size * Vector2(0.25,0.25))
