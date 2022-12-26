extends Node2D

var type
onready var timer = $Timer
var category
var enemy_array = []
var built = false
var enemy
var ready = true

func _ready():
	if built:
		self.get_node('Range/CollisionShape2D').get_shape().radius = 0.5 * GameData.tower_data[type]['range']
		timer.set_wait_time(GameData.tower_data[type]['rof'])
		timer.connect('timeout', self, 'set_fire_ready')


func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		if not get_node('AnimationPlayer').is_playing():
			turn()
		if ready:
			fire()
	else:
		enemy = null


func turn():
	get_node('Turret').look_at(enemy.position)


func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]


func fire():
	ready = false
	if category == 'Projectile':
		fire_gun()
	elif category == 'Missile':
		fire_missile()
	enemy.on_hit(GameData.tower_data[type]['damage'], GameData.tower_data[type]['category'])
	timer.start()


func set_fire_ready():
	ready = true


func fire_gun():
	get_node('AnimationPlayer').play('Fire')


func fire_missile():
	get_node('AnimationPlayer').play('Fire')



func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())


func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
