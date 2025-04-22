extends Node

var node_files: Array = [
	"res://dialogue_editor/nodes/content_node.tscn",
	"res://dialogue_editor/nodes/branch_node.tscn",
	"res://dialogue_editor/nodes/base_node.tscn",
]

var choice_files: Array = [
	"res://dialogue_editor/nodes/choices/base_choice.tscn"
]

var node_types: Dictionary
var choice_types: Dictionary

func _ready():
	for i in node_files:
		node_types.set(load(i).instantiate().get_script().get_global_name(), load(i))
	for i in choice_files:
		choice_types.set(load(i).instantiate().get_script().get_global_name(), load(i))
