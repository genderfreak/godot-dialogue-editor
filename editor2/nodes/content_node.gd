extends BaseNode
class_name ContentNode

@export var content: TextEdit

func save() -> Dictionary:
	var dict = super.save()
	dict.merge({
		"content": content,
	})
	return dict
