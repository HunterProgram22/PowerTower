# warning-ignore-all:unused_signal
extends Node



signal quit_pressed
signal start_game_map(map)

signal new_game_pressed

signal game_finished
signal level_completed(map)

signal cash_changed
signal add_cash(type)
signal deduct_cash(tower_type)

signal enemy_destroyed(type)
signal enemy_off_map
signal base_damage(base_damage)

signal upgrade_turret(current_turret)
signal manual_aim_turret
