# warning-ignore-all:return_value_discarded
extends Node2D


var type: String
var category: String
var enemy_location: PathFollow2D
var enemy_array: Array = []
var built: bool = false
var ready: bool = true

onready var timer: Timer = $Timer



func _ready():
	if built:
		get_node('Range/CollisionShape2D').get_shape().radius = 0.5 * GameData.tower_data[type]['range']
		timer.set_wait_time(GameData.tower_data[type]['rof'])
		timer.connect('timeout', self, 'set_fire_ready')


func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		if not $AnimationPlayer.is_playing():
			turn()
		if ready:
			fire()
	else:
		enemy_location = null


func turn():
	$Turret.look_at(enemy_location.position)


func select_enemy():
	"""Creates an array and selects enemy at end of array.

	The enemy at the end of the array is closest to end of the map.
	"""
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy_location = enemy_array[enemy_index]


func fire():
	ready = false
	if category == 'Projectile':
		fire_gun()
	elif category == 'Missile':
		fire_missile()
	enemy_location.on_hit(GameData.tower_data[type]['damage'], GameData.tower_data[type]['category'])
#	print(GameData.tower_data[type]['damage'])
	timer.start()


func set_fire_ready():
	ready = true


func fire_gun():
	$AnimationPlayer.play('Fire')


func fire_missile():
	$AnimationPlayer.play('Fire')



func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())


func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
