extends Control

class_name SaveHelper

@export var save_node: GraphEdit
@export var autosave_time: float = 10

var autosave_file_path: String

func _ready():
	$SaveDialog.file_selected.connect(save_file_selected)
	$LoadDialog.file_selected.connect(load_file_selected)
	$AutosaveTimer.wait_time=autosave_time
	$AutosaveTimer.start()
	$AutosaveTimer.timeout.connect(_autosave)
	autosave_file_path = "user://autosave_%s.tscn" % Time.get_unix_time_from_system()

func open_save_file_dialog():
	$SaveDialog.popup_centered_ratio()

func save_file_selected(path: String):
	autosave_file_path = path
	for i in save_node.get_children():
		i.set_owner(save_node)
	var packed_scene := PackedScene.new()
	packed_scene.pack(save_node)
	ResourceSaver.save(packed_scene,path)

func open_load_file_dialog():
	$LoadDialog.popup_centered_ratio()

func load_file_selected(path: String):
	var scn = load(path)
	scn = scn.instantiate()
	var parent = save_node.get_parent()
	scn.add_node_menu = save_node.add_node_menu
	save_node.queue_free()
	parent.add_child(scn)
	parent.move_child(scn,0)
	save_node = scn

func _autosave():
	save_file_selected(autosave_file_path)
