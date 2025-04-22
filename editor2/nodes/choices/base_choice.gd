extends Control
class_name BaseChoice

var node_type: String
var metadata: TextEdit
@export var content: TextEdit
var to: Node

## For right click popup
var popup: PopupMenu
var popup_items = [
	["Delete", remove_self],
	["Add/remove metadata", add_metadata],
	["Move up", move.bind(-1)],
	["Move down", move.bind(1)],
]

func _ready():
	node_type = get_script().get_global_name()
	popup = PopupMenu.new()
	add_child(popup)
	popup.size=Vector2(0,0)
	for i in popup_items:
		popup.add_item(i[0])
	popup.index_pressed.connect(func (idx): popup_items[idx][1].call())

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_RIGHT:
		popup.position=get_global_mouse_position()
		popup.popup()
		get_viewport().set_input_as_handled()

func save() -> Dictionary:
	var dict = {
		"content": get_text(),
		"node_type": node_type,
	}
	if metadata:
		# possibly validate metadata json here
		dict.merge({"metadata": metadata.text})
	if to:
		dict.merge({"to": to.name})
	return dict

func load_from(dict):
	content.text = dict["content"]
	if metadata:
		add_metadata()
		metadata.text = dict["metadata"]

func get_text() -> String:
	return content.text

func move(distance: int):
	get_parent().move_choice(self, distance)

func remove_self():
	get_parent().remove_choice(self)

func set_index(idx: int):
	%ID.text = "#%s" % idx

## Adds a textedit to the choice for metadata, or removes it if it exists already.
func add_metadata():
	if metadata:
		remove_child(metadata)
		metadata.queue_free()
		metadata = null
		return
	metadata = TextEdit.new()
	metadata.placeholder_text="metadata"
	metadata.name="metadata"
	metadata.custom_minimum_size.y=36
	metadata.scroll_fit_content_height=true
	metadata.wrap_mode=TextEdit.LINE_WRAPPING_BOUNDARY
	add_child(metadata)
	move_child(metadata,get_children().find(%Margin))
