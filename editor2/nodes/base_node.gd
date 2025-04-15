extends GraphNode
class_name BaseNode

## Generic right click popup
var popup: PopupMenu
var popup_items = [
	["Delete", remove_popup],
	["Add/remove metadata", add_metadata],
]

# Stuff to save
## The TextEdit node, if it exists, which stores metadata. Null if not present.
var metadata: TextEdit
var node_type: String

func _ready():
	resizable = true
	resize_request.connect(_resize)
	popup = PopupMenu.new()
	add_child(popup)
	popup.size=Vector2(0,0)
	for i in popup_items:
		popup.add_item(i[0])
	popup.index_pressed.connect(_popup_pressed)
	node_type = get_script().get_global_name()

## Handle resize requests from signal
func _resize(v2):
	size=v2

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_RIGHT:
		popup.position=get_global_mouse_position()
		popup.popup()
		get_viewport().set_input_as_handled()

## Called when the right-click menu is triggered
func _popup_pressed(idx):
	popup_items[idx][1].call()

## Show a popup that asks the user if they want to remove the node
func remove_popup():
	var dialog = ConfirmationDialog.new()
	dialog.dialog_text="Are you sure you want to delete this node?"
	dialog.confirmed.connect(remove_self)
	dialog.dialog_autowrap = true
	dialog.size=Vector2(200,100)
	dialog.position=get_global_mouse_position()-(Vector2(dialog.size)*Vector2(0.5,0.5))
	add_child(dialog)
	dialog.popup()

## Remove the node.
func remove_self():
	get_parent().remove_child(self)
	queue_free()

## Adds a textedit to the node for metadata, or removes it if it exists already.
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

## Returns a dictionary of all relevant information needed to save/load object
func save() -> Dictionary:
	var dict = {
		"metadata": metadata,
	}
	dict.merge(get_graph_data())
	return dict

## Returns data used to recreate the node graph
func get_graph_data() -> Dictionary:
	return {"node_type": node_type,
	"size": {"x":size.x,"y":size.y},
	"position_offset": {"x": position_offset.x, "y": position_offset.y}}
