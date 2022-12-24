extends "res://Scenes/Turrets/Turrets.gd"


func _on_Range_body_exited(body):
	._on_Range_body_exited(body)
	if enemy_array.size() == 0:
		reload_missile()


func reload_missile():
	get_node("Turret/Missile1").set_visible(true)
	get_node("Turret/Missile2").set_visible(true)
