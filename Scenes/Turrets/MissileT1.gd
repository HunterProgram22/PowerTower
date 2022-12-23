extends "res://Scenes/Turrets/Turrets.gd"

var missile = preload("res://Scenes/SupportScenes/Missile.tscn")

var turret_aim = Vector2.ZERO

func _process(delta):
	MissileLoop()


func _on_Range_body_exited(body):
	._on_Range_body_exited(body)
	if enemy_array.size() == 0:
		reload_missile()


func reload_missile():
	get_node("Turret/Missile1").set_visible(true)
	get_node("Turret/Missile2").set_visible(true)


func MissileLoop():
	var missile_instance = missile.instance()
	missile_instance.position = get_global_position()
	missile_instance.rotation = get_angle_to(turret_aim)
	get_parent().add_child(missile_instance)
