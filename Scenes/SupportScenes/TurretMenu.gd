extends Node2D

enum PopupIds {
	SHOW_LAST_MOUSE_POSITION = 100,
	SAY_HI,
}

var _last_mouse_position

onready var _pm = $PopupMenu



func _ready():
	_pm.add_item('Upgrade Turret', PopupIds.SHOW_LAST_MOUSE_POSITION)
	_pm.add_item('Manual Aim Turret', PopupIds.SAY_HI)
	_pm.connect('id_pressed', self, '_on_PopupMenu_id_pressed')
	_pm.connect('index_pressed', self, '_on_PopupMenu_index_pressed')


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		_last_mouse_position = get_global_mouse_position()
#		_pm.popup(Rect2(_last_mouse_position.x, _last_mouse_position.y, _pm.rect_size.x, _pm.rect_size.y))
		_pm.popup(Rect2(_last_mouse_position.x, _last_mouse_position.y, 50, 50))
		print_debug(_pm.rect_size.x)


func _on_PopupMenu_id_pressed(id):
	print_debug(id)

	match id:
		PopupIds.SHOW_LAST_MOUSE_POSITION:
			print(_last_mouse_position)
		PopupIds.SAY_HI:
			print('hi')


func _on_PopupMenu_index_pressed(index):
	print_debug(index)
