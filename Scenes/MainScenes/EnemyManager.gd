# warning-ignore-all:return_value_discarded
extends Node2D

var map_name: String
var current_wave_count: int = 0
var enemies_in_wave: int = 0
var enemies_in_stage: int = 0
var wave_data: Array = []

onready var timer: Timer = $Timer
onready var enemy_create_timer: Timer = $EnemyCreateTimer
onready var map: Node2D = get_parent().map
onready var i = 0
onready var wave



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
	var next_wave = retrieve_wave()
	spawn_enemies(next_wave)


func retrieve_wave() -> Array:
	wave = wave_data[current_wave_count]
	current_wave_count += 1
	enemies_in_wave = wave['wave_count']
	return wave


func spawn_enemies(current_wave: Dictionary) -> void:
	var wave_timer = Timer.new()
	add_child(wave_timer)
	wave_timer.connect('timeout', self, '_next', [wave_timer])
	wave_timer.set_wait_time(current_wave['wave_speed'])
	wave_timer.set_one_shot(true)
	wave_timer.start()

	if current_wave_count < wave_data.size():
		yield(get_tree().create_timer(10.0), 'timeout')  # Padding between waves
		i = 0
		start_next_wave()
		get_parent().get_node('UI').update_wave_ui()


func _next(wave_timer):
	var enemy_type = wave['wave_type']
	var enemy_count = wave['wave_count']
	if wave_timer.is_stopped() and i < enemy_count:
		var new_enemy = load('res://Scenes/Enemies/' + enemy_type + '.tscn').instance()
		new_enemy.type = enemy_type
		get_parent().get_node('Map/Path').add_child(new_enemy, true)
		i += 1
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
