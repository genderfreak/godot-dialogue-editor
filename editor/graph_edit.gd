extends GraphEdit

@export var add_node_menu: MenuButton

@onready var nodes = {
	"BaseNode": preload("res://editor2/nodes/base_node.tscn"),
	"ContentNode": preload("res://editor2/nodes/content_node.tscn"),
}

var right_clicked = false

func _ready():
	assert(add_node_menu)
	for i in nodes:
		add_node_menu.get_popup().add_item(i)
	add_node_menu.get_popup().id_pressed.connect(_add_node_pressed)
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_RIGHT:
		right_clicked=true
		var popup = add_node_menu.get_popup()
		popup.position=get_global_mouse_position()
		popup.popup()
		get_viewport().set_input_as_handled()

func get_nodes_connected_to(from_node: StringName, from_port: int):
	var array = []
	for node in connections:
		if node.from_node == from_node and node.from_port == from_port:
			array.append({"to_node": node.to_node,"to_port": node.to_port})
	return array

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if get_connection_count(from_node, from_port):
		for node in get_nodes_connected_to(from_node,from_port):
			disconnect_node(from_node,from_port,node.to_node,node.to_port)
	connect_node(from_node,from_port,to_node,to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node,from_port,to_node,to_port)

func _add_node_pressed(idx):
	var key = add_node_menu.get_popup().get_item_text(idx)
	var instance = nodes[key].instantiate()
	add_child(instance)
	if right_clicked:
		instance.position_offset = (get_local_mouse_position() + scroll_offset) / zoom
	else:
		instance.position_offset = scroll_offset + (size * Vector2(0.25,0.25))
