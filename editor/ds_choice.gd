extends VBoxContainer
class_name DSChoice

var __content: String = ""

## Dropdown menu options
var menu_options: Array = [
	["Remove choice", remove],
	["Change Type (not implemented)", change_type_pressed],
]

## ID number on label
var number: int:
	set(new):
		number = new
		%ID.text = "#%s" % number

## Emitted when the user clicks the X or remove() is otherwise called
signal remove_choice(choice)

func _ready():
	%TextEdit.text_changed.connect(_text_edit_changed)
	var menu_popup: PopupMenu = %Menu.get_popup()
	for i in menu_options:
		menu_popup.add_item(i[0])
	menu_popup.index_pressed.connect(_popup_pressed)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and \
	event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		%Menu.get_popup().position=get_global_mouse_position()
		%Menu.get_popup().size=Vector2(0,0)
		%Menu.get_popup().popup()
		get_viewport().set_input_as_handled()

func _text_edit_changed():
	__content = %TextEdit.text

func _popup_pressed(idx):
	menu_options[idx][1].call()

## Sets the content of the choice
func set_content(c):
	__content = c
	%TextEdit.text = c

## Returns the content of the choice
func get_content():
	return __content

## bring up change type popup
func change_type_pressed():
	pass

## Emit remove signal
func remove():
	remove_choice.emit(self)
