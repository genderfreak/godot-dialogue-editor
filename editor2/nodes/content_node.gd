extends BaseNode
class_name ContentNode

@export var content: TextEdit

func save() -> Dictionary:
	var dict = super.save()
	dict.merge({
		"content": content.text,
	})
	return dict

func load_from(dict):
	super.load_from(dict)
	content.text = dict["content"]
