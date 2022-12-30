extends Area2D

var built: bool = false
var turret_scene = preload('res://Scenes/SupportScenes/TurretMenu.tscn')
var _last_mouse_position


func _ready():
	built = get_parent().built
	Events.connect('upgrade_turret', self, 'upgrade_turret')
	Events.connect('manual_aim_turret', self, 'set_turret_to_manual')
#	built = true  # For scene testing uncomment


func _input_event(_viewport, event, _shape_idx):
	if built:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			_last_mouse_position = get_global_mouse_position()
			var turret_menu = turret_scene.instance()
			add_child(turret_menu)
			$TurretMenu/PopupMenu.popup(Rect2(_last_mouse_position.x, _last_mouse_position.y, 100, 100))


func upgrade_turret():
	print('Upgrading turret')


func set_turret_to_manual():
	print('Setting turret to manual')
