extends Node2D

signal game_finished(result)
signal level_completed

var map_node = 'Test'
var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type

var current_wave = 0
var enemies_in_wave = 0
var enemies_in_stage = 0

var base_health = 100
var wave_data = []



func _ready():
	wave_data = WaveData.wave_data[map_node]
	map_node = load('res://Scenes/Maps/' + map_node + '.tscn').instance()
	add_child(map_node)
	enemies_in_stage = get_total_enemies()
	for i in get_tree().get_nodes_in_group('build_buttons'):
		i.connect('pressed', self, 'initiate_build_mode', [i.get_name()])


func get_total_enemies():
	for i in range(wave_data.size()):
		enemies_in_stage += wave_data[i].size()
	return enemies_in_stage


func _process(delta):
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
	var current_tile = map_node.get_node('TowerExclusion').world_to_map(mouse_position)
	var tile_position = map_node.get_node('TowerExclusion').map_to_world(current_tile)
	
	if map_node.get_node('TowerExclusion').get_cellv(current_tile) == -1:
		get_node('UI').update_tower_preview(tile_position, 'ad54ff3c')
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node('UI').update_tower_preview(tile_position, 'adff4545')
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
		new_enemy.connect('base_damage', self, 'on_base_damage')
		new_enemy.connect('enemy_destroyed', self, 'update_enemy_count')
		map_node.get_node('Path').add_child(new_enemy, true)
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
		var new_tower = load('res://Scenes/Turrets/' + build_type + '.tscn').instance()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]['category']
		map_node.get_node('Turrets').add_child(new_tower, true)
		map_node.get_node('TowerExclusion').set_cellv(build_tile, 5)
		## deduct cash
		## update cash label


func update_enemy_count():
	enemies_in_stage = enemies_in_stage - 1
	if enemies_in_stage == 0:
		emit_signal('level_completed')


func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		emit_signal('game_finished', false)
	else:
		get_node('UI').update_health_bar(base_health)
