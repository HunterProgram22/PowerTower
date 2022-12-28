# warning-ignore-all:return_value_discarded
extends Node2D

var map_name: String
var current_wave: int = 0
var enemies_in_wave: int = 0
var enemies_in_stage: int = 0
var wave_data: Array = []

onready var timer: Timer = $Timer
onready var map: Node2D = get_parent().map



func _ready() -> void:
	connect_signals()
	map_name = get_parent().map_name
	wave_data = WaveData.wave_data[map_name]
	enemies_in_stage = get_total_enemies()


func connect_signals():
	Events.connect('enemy_destroyed', self, 'update_enemy_count')


func get_total_enemies() -> int:
	for i in range(wave_data.size()):
		enemies_in_stage += wave_data[i].size()
	return enemies_in_stage


func start_next_wave() -> void:
	var next_wave = retrieve_wave()
	spawn_enemies(next_wave)


func retrieve_wave() -> Array:
	var wave = wave_data[current_wave]
	current_wave += 1
	enemies_in_wave = wave.size()
	return wave


func spawn_enemies(wave: Array) -> void:
	"""The wave Array contains a list of enemies.

	Each enemy in the list is in the format ('UnitName'[str], DelayTime[float]).
	"""
	for enemy_data in wave:
		var new_enemy = load('res://Scenes/Enemies/' + enemy_data[0] + '.tscn').instance()
		new_enemy.type = enemy_data[0]
		get_parent().get_node('Map/Path').add_child(new_enemy, true)
		yield(get_tree().create_timer(enemy_data[1]), 'timeout')  # Padding between enemies
	if current_wave < wave_data.size():
		yield(get_tree().create_timer(2.0), 'timeout')  # Padding between waves
		start_next_wave()
		get_parent().get_node('UI').update_wave_ui()


func update_enemy_count(type: String) -> void:
	enemies_in_stage = enemies_in_stage - 1
	Events.emit_signal('add_cash', type)
	if enemies_in_stage == 0:
		timer.connect('timeout', self, 'all_enemies_destroyed')
		timer.set_one_shot(true)
		timer.set_wait_time(3.0)
		timer.start()
		print('Timer run')


func all_enemies_destroyed() -> void:
	Events.emit_signal('level_completed', map_name)
