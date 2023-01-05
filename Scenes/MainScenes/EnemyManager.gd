# warning-ignore-all:return_value_discarded
extends Node2D

var map_name: String
var current_wave_count: int = 0
var enemies_in_stage: int = 0
var wave_data: Array = []

onready var timer: Timer = $Timer
onready var map: Node2D = get_parent().map
onready var wave_enemies_spawned: int = 0



func _ready() -> void:
	connect_signals()
	map_name = get_parent().map_name
	wave_data = WaveData.wave_data[map_name]
	enemies_in_stage = get_total_enemies()


func connect_signals():
	Events.connect('enemy_destroyed', self, 'update_enemy_count')
	Events.connect('enemy_off_map', self, 'update_enemy_count_nocash')


func get_total_enemies() -> int:
	for x in range(wave_data.size()):
		enemies_in_stage += wave_data[x]['wave_count']
	return enemies_in_stage


func start_next_wave() -> void:
	var _next_wave = retrieve_wave()
	current_wave_count += 1
	spawn_enemies(_next_wave)


func retrieve_wave() -> Array:
	return wave_data[current_wave_count]


func spawn_enemies(current_wave: Dictionary) -> void:
	var wave_timer = Timer.new()
	add_child(wave_timer)
	wave_timer.connect('timeout', self, '_next', [current_wave, wave_timer])
	wave_timer.set_wait_time(current_wave['wave_speed'])
	wave_timer.set_one_shot(true)
	wave_timer.start()
	check_for_next_wave(current_wave)


func check_for_next_wave(current_wave: Dictionary) -> void:
	if current_wave_count < wave_data.size():
		var _wave_padding = (current_wave['wave_count'] * current_wave['wave_speed']) + 3.0
		yield(get_tree().create_timer(_wave_padding), 'timeout')
		wave_enemies_spawned = 0
		start_next_wave()
		get_parent().get_node('UI').update_wave_ui()


func _next(current_wave: Dictionary, wave_timer: Timer) -> void:
	var _enemy_type = current_wave['wave_type']
	var _enemy_count = current_wave['wave_count']
	if wave_timer.is_stopped() and wave_enemies_spawned < _enemy_count:
		var new_enemy = load('res://Scenes/Enemies/' + _enemy_type + '.tscn').instance()
		new_enemy.type = _enemy_type
		get_parent().get_node('Map/Path').add_child(new_enemy, true)
		wave_enemies_spawned += 1
		wave_timer.start()


func update_enemy_count(type: String) -> void:
	enemies_in_stage = enemies_in_stage - 1
	Events.emit_signal('add_cash', type)
	if enemies_in_stage == 0:
		timer.connect('timeout', self, 'all_enemies_destroyed')
		timer.set_one_shot(true)
		timer.set_wait_time(3.0)
		timer.start()


func update_enemy_count_nocash() -> void:
	enemies_in_stage = enemies_in_stage - 1


func all_enemies_destroyed() -> void:
	Events.emit_signal('level_completed', map_name)
