extends Node

var node_files: Array = [
	"res://editor2/nodes/base_node.tscn",
	"res://editor2/nodes/content_node.tscn",
]

var node_types: Dictionary

func _ready():
	for i in node_files:
		node_types.set(load(i).instantiate().get_script().get_global_name(), i)
