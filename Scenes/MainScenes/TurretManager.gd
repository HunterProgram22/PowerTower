extends Node2D

const GREEN: String = 'ad54ff3c'
const RED: String = 'adff4545'

var build_type: String
var build_tile: Vector2
var build_location: Vector2
var build_valid: bool = false
var build_mode: bool = false

onready var cash_node: Label = get_parent().get_node('UI/HUD/InfoBar/H/Money')
onready var ui_node: CanvasLayer = get_parent().get_node('UI')


func _ready():
	connect_signals()
	for i in get_tree().get_nodes_in_group('build_buttons'):
		i.connect('pressed', self, 'initiate_build_mode', [i.get_name()])


func connect_signals():
	Events.connect('upgrade_turret', self, 'on_upgrade_turret')


func update_tower_preview() -> void:
	var tower_exclusion = get_parent().get_node('Map/TowerExclusion')
	var mouse_position = get_global_mouse_position()
	var current_tile = tower_exclusion.world_to_map(mouse_position)
	var tile_position = tower_exclusion.map_to_world(current_tile)

	if tower_exclusion.get_cellv(current_tile) == -1:
		ui_node.update_tower_preview(tile_position, GREEN)
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		ui_node.update_tower_preview(tile_position, RED)
		build_valid = false


func initiate_build_mode(tower_type: String) -> void:
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + 'T1'
	build_mode = true
	ui_node.set_tower_preview(build_type, get_global_mouse_position())


func cancel_build_mode() -> void:
	build_mode = false
	build_valid = false
	ui_node.get_node('TowerPreview').free()


func verify_and_build() -> void:
	var turret_node = get_parent().get_node('Map/Turrets')
	var tower_exclusion = get_parent().get_node('Map/TowerExclusion')
	if build_valid:
		var new_tower = load('res://Scenes/Turrets/' + build_type + '.tscn').instance()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]['category']
		turret_node.add_child(new_tower, true)
		tower_exclusion.set_cellv(build_tile, 5)
		Events.emit_signal('deduct_cash', new_tower.type)


func on_upgrade_turret(current_turret: Node2D) -> void:
	"""Category and position must be added after new_turret is added to tree."""
	var upgrade_cost = get_upgrade_cost(current_turret)
	var turret_node = get_parent().get_node('Map/Turrets')
	if upgrade_cost > int(cash_node.text):
		print('not enough cash')
	else:
		var current_tile = current_turret.position
		current_turret.queue_free()
		var new_turret = load('res://Scenes/Turrets/GunT2.tscn').instance()
		new_turret.built = true
		new_turret.type = 'GunT2'
		new_turret.category = GameData.tower_data[new_turret.type]['category']
		new_turret.position = current_tile
		turret_node.add_child(new_turret)


func get_upgrade_cost(current_turret: Node2D) -> int:
	var new_turret_level = int(current_turret.type[-1])
	new_turret_level += 1
	print(new_turret_level)
	print(current_turret.type.split('T'))
	var substring = current_turret.type.split('T')[0]
	var new_turret_type = substring + 'T' + str(new_turret_level)
	print(new_turret_type)
	var cost = GameData.tower_data[new_turret_type]['cost']
	print(cost)
	return cost
