extends Node2D

enum PopupIds {
	UPGRADE_TURRET,
	MANUAL_AIM_TURRET,
}

onready var _pm: PopupMenu = $PopupMenu
onready var time_pressed: int = 0
onready var time_last_pressed: int = 101
onready var time_between_presses: int = 0



func _ready():
	_pm.add_item('Upgrade Turret', PopupIds.UPGRADE_TURRET)
	_pm.add_item('Manual Aim Turret', PopupIds.MANUAL_AIM_TURRET)
	_pm.connect('id_pressed', self, '_on_PopupMenu_id_pressed')


func _on_PopupMenu_id_pressed(id):
	time_pressed = Time.get_ticks_msec()
	if time_pressed - time_last_pressed < 100:
		return
	else:
		var current_turret = get_node('../..')
		time_pressed = Time.get_ticks_msec()
		time_last_pressed = time_pressed
		match id:
			PopupIds.UPGRADE_TURRET:
				Events.emit_signal('upgrade_turret', current_turret)
			PopupIds.MANUAL_AIM_TURRET:
				Events.emit_signal('manual_aim_turret', current_turret)
