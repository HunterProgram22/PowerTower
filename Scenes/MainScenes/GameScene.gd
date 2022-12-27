# warning-ignore-all:return_value_discarded
extends Node2D

const GREEN: String = 'ad54ff3c'
const RED: String = 'adff4545'

var build_tile: Vector2
var build_location: Vector2
var build_type: String
var map: Node2D
var map_name: String
var build_mode: bool = false
var build_valid: bool = false
var current_wave: int = 0
var enemies_in_wave: int = 0
var enemies_in_stage: int = 0
var base_health: int = 100
var wave_data: Array = []

onready var timer: Timer = $Timer



func _ready():
	connect_signals()
	wave_data = WaveData.wave_data[map_name]
	map = load('res://Scenes/Maps/' + map_name + '.tscn').instance()
	add_child(map)
	enemies_in_stage = get_total_enemies()
	for i in get_tree().get_nodes_in_group('build_buttons'):
		i.connect('pressed', self, 'initiate_build_mode', [i.get_name()])


func connect_signals():
	Events.connect('enemy_destroyed', self, 'update_enemy_count')
	Events.connect('base_damage', self, 'on_base_damage')


func get_total_enemies():
	for i in range(wave_data.size()):
		enemies_in_stage += wave_data[i].size()
	print('enemies')
	print(enemies_in_stage)
	return enemies_in_stage


func _process(_delta):
	if build_mode:
		update_tower_preview()


func _unhandled_input(event):
	if event.is_action_released('ui_cancel') and build_mode == true:
		cancel_build_mode()
	if event.is_action_released('ui_accept') and build_mode == true:
		verify_and_build()
		cancel_build_mode()


func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map.get_node('TowerExclusion').world_to_map(mouse_position)
	var tile_position = map.get_node('TowerExclusion').map_to_world(current_tile)
	
	if map.get_node('TowerExclusion').get_cellv(current_tile) == -1:
		$UI.update_tower_preview(tile_position, GREEN)
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		$UI.update_tower_preview(tile_position, RED)
		build_valid = false


##
## Wave Functions
##
func start_next_wave():
	var next_wave = retrieve_wave()
	spawn_enemies(next_wave)


func retrieve_wave():
	var wave = wave_data[current_wave]
	current_wave += 1
	enemies_in_wave = wave.size()
	return wave


func spawn_enemies(wave):
	for enemy_data in wave:
		var new_enemy = load('res://Scenes/Enemies/' + enemy_data[0] + '.tscn').instance()
		new_enemy.type = enemy_data[0]
#		new_enemy.connect('base_damage', self, 'on_base_damage')
		map.get_node('Path').add_child(new_enemy, true)
		yield(get_tree().create_timer(enemy_data[1]), 'timeout')
	if current_wave < wave_data.size():
		yield(get_tree().create_timer(2.0), 'timeout')  ## Padding between waves
		start_next_wave()
		get_node('UI').update_wave_ui()


##
## Building Functions
##

func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + 'T1'
	build_mode = true
	get_node('UI').set_tower_preview(build_type, get_global_mouse_position())


func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node('UI/TowerPreview').free()


func verify_and_build():
	if build_valid:
		## Test to verify player has enough cash
		var cost = GameData.tower_data[build_type]['cost']
		var cash_available_node = get_node('UI/HUD/InfoBar/H/Money')
		var cash_available = int(cash_available_node.text)
		if cash_available >= cost:
			var new_tower = load('res://Scenes/Turrets/' + build_type + '.tscn').instance()
			new_tower.position = build_location
			new_tower.built = true
			new_tower.type = build_type
			new_tower.category = GameData.tower_data[build_type]['category']
			map.get_node('Turrets').add_child(new_tower, true)
			map.get_node('TowerExclusion').set_cellv(build_tile, 5)

			## deduct cash
			cash_available = cash_available - cost
			## update cash label
			cash_available_node.text = str(cash_available)
			Events.emit_signal('cash_changed')
		else:
			print('not enough cash')


func add_cash(type):
	var cash_to_add = GameData.tank_data[type]['value']
	var cash_node = get_node('UI/HUD/InfoBar/H/Money')
	var new_cash = int(cash_node.text) + cash_to_add
	cash_node.text = str(new_cash)
	Events.emit_signal('cash_changed')


func update_enemy_count(type):
	enemies_in_stage = enemies_in_stage - 1
	add_cash(type)
	print(enemies_in_stage)
	if enemies_in_stage == 0:
		timer.connect('timeout', self, 'all_enemies_destroyed')
		timer.set_one_shot(true)
		timer.set_wait_time(3.0)
		timer.start()
		print('Timer run')

func all_enemies_destroyed():
	Events.emit_signal('level_completed', map_name)


func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		Events.emit_signal('game_finished')
	else:
		$UI.update_health_bar(base_health)
