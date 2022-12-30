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


func _on_PopupMenu_id_pressed(id):
#	print_debug(Time.get_ticks_msec())
	var current_turret = get_node('../..')
	match id:
		PopupIds.UPGRADE_TURRET:
			Events.emit_signal('upgrade_turret', current_turret)
		PopupIds.MANUAL_AIM_TURRET:
			Events.emit_signal('manual_aim_turret', current_turret)
