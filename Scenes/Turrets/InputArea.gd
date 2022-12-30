extends Area2D

var built: bool = false


func _ready():
	print(get_parent())
	built = get_parent().built
	print(built)


func _input_event(_viewport, event, _shape_idx):
	if built:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		    var popup = get_parent().get_node('UI/PopupPanel')
		    popup.popup_centered()
		    print(popup)

#			var current_turret = get_parent()
#			Events.emit_signal('upgrade_turret', current_turret)


