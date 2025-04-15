extends Control

@onready var file_menu_options = [
	["Save", null],
	["Load", null],
	["Export", null],
]

func _ready():
	for i in file_menu_options:
		%FileMenu.get_popup().add_item(i[0])
	%FileMenu.get_popup().id_pressed.connect(func (idx: int): file_menu_options[idx][1].call())
