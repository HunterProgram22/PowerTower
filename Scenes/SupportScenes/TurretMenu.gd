extends Node2D

enum PopupIds {
	UPGRADE_TURRET,
	MANUAL_AIM_TURRET,
}

onready var _pm = $PopupMenu



func _ready():
	_pm.add_item('Upgrade Turret', PopupIds.UPGRADE_TURRET)
	_pm.add_item('Manual Aim Turret', PopupIds.MANUAL_AIM_TURRET)
	_pm.connect('id_pressed', self, '_on_PopupMenu_id_pressed')
	_pm.connect('index_pressed', self, '_on_PopupMenu_index_pressed')


func _on_PopupMenu_id_pressed(id):
	match id:
		PopupIds.UPGRADE_TURRET:
			Events.emit_signal('upgrade_turret')
		PopupIds.MANUAL_AIM_TURRET:
			Events.emit_signal('manual_aim_turret')


func _on_PopupMenu_index_pressed(index):
	print_debug(index)
