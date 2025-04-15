extends DSBaseNode

@onready var choice_types: Dictionary = {
	"Choice": preload("res://editor/ds_choice.tscn"),
	"Sticky Choice (unimplemented)": preload("res://editor/ds_choice.tscn"),
	"Conditional Choice (unimplemented)": preload("res://editor/ds_choice.tscn"),
}

@onready var add_choice_popup: PopupMenu = %Button.get_popup()

var choices: Array = []

func _ready():
	super._ready()
	add_choice(choice_types["Choice"].instantiate())
	for i in choice_types:
		add_choice_popup.add_item(i)
	add_choice_popup.id_pressed.connect(_add_choice_pressed)

func _add_choice_pressed(idx):
	var key = add_choice_popup.get_item_text(idx)
	add_choice(choice_types[key].instantiate())

func add_choice(instance: DSChoice):
	choices.append(instance)
	instance.number=len(choices)-1
	instance.remove_choice.connect(remove_choice)
	add_child(instance)
	move_child(instance,len(choices)-1)
	set_slot_enabled_right(instance.number,true)

func remove_choice(choice: DSChoice):
	var idx = choices.find(choice)
	choices.remove_at(idx)
	var c = 1
	for i in choices.slice(idx):
		i.number = idx + c
		c+=1
	remove_child(choice)
	choice.queue_free()
