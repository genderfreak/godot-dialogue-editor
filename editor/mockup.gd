extends GraphEdit

var node = preload("res://node.tscn")

enum OPTIONS {SAVE, LOAD, EXPORT}

func get_nodes_connected_to(from_node: StringName, from_port: int):
	var array = []
	for node in connections:
		if node.from_node == from_node and node.from_port == from_port:
			array.append({"to_node": node.to_node,"to_port": node.to_port})
	return array

func _ready():
	%MenuButton.get_child(0, true).index_pressed.connect(_on_menu_item_pressed)

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if get_connection_count(from_node, from_port):
		for node in get_nodes_connected_to(from_node,from_port):
			disconnect_node(from_node,from_port,node.to_node,node.to_port)
	connect_node(from_node,from_port,to_node,to_port)

func _on_button_pressed() -> void:
	var n = node.instantiate()
	add_child(n)

func _on_menu_item_pressed(idx) -> void:
	match idx:
		OPTIONS.SAVE:
			pass
		OPTIONS.LOAD:
			pass
		OPTIONS.EXPORT:
			export_graph_to_json()

func export_graph_to_json():
	var dict = {}
	for i in get_children():
		if i is GraphElement:
			print(get_nodes_connected_to(i.name,0))


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	print("disconnect")
	disconnect_node(from_node,from_port,to_node,to_port)
