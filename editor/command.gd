extends RefCounted

var functions: Dictionary = {
	"execute": null,
	"undo": null
}

func _init():
	print(functions.execute)
