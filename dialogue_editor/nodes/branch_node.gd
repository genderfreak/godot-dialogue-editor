extends BaseNode
class_name BranchNode

var choices : Array = []

@onready var add_choice_popup: PopupMenu = %Button.get_popup()

func _ready():
	super._ready()
	add_choice_popup.index_pressed.connect(_pressed)
	for i in DialogueEditorSettings.choice_types:
		add_choice_popup.add_item(i)

func save() -> Dictionary:
	var dict = super.save()
	var arr = []
	# For every choice, add choice to array and save it
	for c in choices:
		arr.append(c.save())
	dict.merge({"choices": arr})
	return dict

func load_from(dict: Dictionary):
	super.load_from(dict)
	for c in dict["choices"]:
		assert(c is Dictionary)
		var ch = DialogueEditorSettings.choice_types[c["node_type"]].instantiate()
		ch.load_from(c)
		add_choice(ch)

func set_destination(from_port: int, to_node: Node):
	choices[from_port].to = to_node

func unset_destination(from_port: int):
	choices[from_port].to = null

func _pressed(idx):
	var key = add_choice_popup.get_item_text(idx)
	var instance: BaseChoice = DialogueEditorSettings.choice_types[key].instantiate()
	add_choice(instance)

func add_choice(instance: Node):
	add_child(instance)
	choices.append(instance)
	move_child(instance, -1+len(choices))
	update_index(instance)
	enable_choice(instance)

func remove_choice(instance: Node):
	assert(instance in choices)
	var pos = choices.find(instance)
	choices.remove_at(pos)
	remove_child(instance)
	instance.queue_free()
	set_slot_enabled_right(len(choices),false)

func move_choice(instance: Node, distance: int):
	assert(instance in choices)
	var pos = choices.find(instance)
	var new_pos = pos + distance
	if new_pos < 0 or new_pos > len(choices)-1:
		print("out of bounds, not moving choice")
		return
	choices.remove_at(pos)
	choices.insert(new_pos,instance)
	move_child(instance,new_pos)
	for i in get_children():
		if i is BaseChoice:
			update_index(i)

func enable_choice(instance: Node,enabled: bool = true):
	set_slot_enabled_right(instance.get_index(),enabled)

func update_index(instance):
	instance.set_index(instance.get_index())
