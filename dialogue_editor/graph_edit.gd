extends GraphEdit

signal right_clicked

func _ready():
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_RIGHT:
		right_clicked.emit()

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
	connect_dialog_node(from_node,from_port,to_node,to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_dialog_node(from_node,from_port,to_node,to_port)

func connect_dialog_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	get_node(NodePath(from_node)).set_destination(from_port,get_node(NodePath(to_node)))
	connect_node(from_node,from_port,to_node,to_port)

func disconnect_dialog_node(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	get_node(NodePath(from_node)).unset_destination(from_port)
	disconnect_node(from_node,from_port,to_node,to_port)

func save_to_file(path: String):
	var dict = {}
	for child in get_children():
		if child is BaseNode:
			dict[child.name] = child.save()
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(JSON.stringify(dict, "  "))
	file.close()

func load_from_file(path: String):
	for i in get_children():
		if i is GraphNode:
			remove_child(i)
			i.queue_free()
	var file = FileAccess.open(path,FileAccess.READ)
	var json = JSON.new()
	var err = json.parse(file.get_as_text())
	if err==OK:
		if json.data is Dictionary:
			pass
		else:
			push_warning("JSON failure, laugh at this user! (unexpected data type %s)" % type_string(typeof(json.data)))
	else:
		push_warning("JSON Parse Error: " + json.get_error_message(), " at line ", json.get_error_line())
	var to_connect = []
	for i in json.data:
		var new_node = DialogueEditorSettings.node_types[json.data[i]["node_type"]].instantiate()
		new_node.name=i
		new_node.load_from(json.data[i])
		add_child(new_node)
		if json.data[i].has("to"):
			to_connect.append([i, 0, json.data[i]["to"]])
		elif json.data[i].has("choices"):
			var count = 0
			for c in json.data[i]["choices"]:
				if c.has("to"):
					to_connect.append([i,count,c["to"]])
				count+=1
	for c in to_connect:
		connect_dialog_node(c[0],c[1],c[2],0)
