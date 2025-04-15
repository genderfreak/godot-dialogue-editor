extends GraphNode
class_name DSBaseNode

var popup: PopupMenu

var popup_items = [
	["Delete", remove_self],
	["Add/remove metadata", add_metadata],
	["Change type (unimplemented)", change_type],
]

var metadata: TextEdit

func _ready():
	resizable = true
	resize_request.connect(_resize)
	popup = PopupMenu.new()
	add_child(popup)
	popup.size=Vector2(0,0)
	for i in popup_items:
		popup.add_item(i[0])
	popup.index_pressed.connect(_popup_pressed)

func _resize(v2):
	size=v2

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_RIGHT:
		popup.position=get_global_mouse_position()
		popup.popup()
		get_viewport().set_input_as_handled()

func _popup_pressed(idx):
	popup_items[idx][1].call()

func remove_self():
	get_parent().remove_child(self)
	queue_free()

func add_metadata():
	if metadata:
		remove_child(metadata)
		metadata.queue_free()
		metadata = null
		return
	metadata = TextEdit.new()
	metadata.placeholder_text="{'key': 'put json here, like',\n'speaker': 'some_character_name'}"
	metadata.name="metadata"
	metadata.custom_minimum_size.y=36
	metadata.scroll_fit_content_height=true
	metadata.wrap_mode=TextEdit.LINE_WRAPPING_BOUNDARY
	add_child(metadata)

func change_type():
	pass
