# BaseTank.gd

extends PathFollow2D

var type

signal base_damage(damage)
signal enemy_destroyed()

var speed = 0
var hp = 0
var base_damage = 0


onready var health_bar = get_node('HealthBar')
onready var impact_area = get_node('Impact')

var projectile_impact = preload('res://Scenes/SupportScenes/ProjectileImpact.tscn')
var missile_impact = preload('res://Scenes/SupportScenes/MissileImpact.tscn')


func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)


func _physics_process(delta):
	if unit_offset == 1.0:
		emit_signal('base_damage', base_damage)
		queue_free()
	move(delta)


func move(delta):
	set_offset(get_offset() + speed * delta)
	health_bar.set_position(position - Vector2(30, 30))


func on_hit(damage, impact_category):
	impact(impact_category)
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()


func impact(impact_category):
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = _get_impact_type(impact_category)
	new_impact.position = impact_location
	impact_area.add_child(new_impact)


func _get_impact_type(impact_category):
	if impact_category == 'Projectile':
		return projectile_impact.instance()
	elif impact_category == 'Missile':
		return missile_impact.instance()


func on_destroy():
	get_node('KinematicBody2D').queue_free()
	emit_signal('enemy_destroyed')
	self.queue_free()
