extends Area2D

var built: bool = false


func _ready():
	print(get_parent())
	built = get_parent().built
	print(built)


func _input_event(viewport, event, shape_idx):
	if built:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			print(get_parent())
			var gun = get_parent()
			var current_tile = gun.position
			print(current_tile)
			var turrets = gun.get_parent()
			print(turrets)
			print(self)
			print('Clicked')
			var current_turret = get_parent()
			turrets.remove_child(current_turret)
			current_turret.call_deferred('free')
			var new_turret = load('res://Scenes/Turrets/GunT2.tscn').instance()
			new_turret.position = current_tile
			new_turret.built = true
			new_turret.type = 'GunT2'
			new_turret.category = GameData.tower_data[new_turret.type]['category']
			print(new_turret)
			turrets.add_child(new_turret)

