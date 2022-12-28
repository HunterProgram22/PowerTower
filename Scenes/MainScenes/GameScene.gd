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
var base_health: int = 100

onready var cash_node: Label = $UI/HUD/InfoBar/H/Money



func _ready() -> void:
	connect_signals()
	map = load('res://Scenes/Maps/' + map_name + '.tscn').instance()
	add_child(map)
	for i in get_tree().get_nodes_in_group('build_buttons'):
		i.connect('pressed', self, 'initiate_build_mode', [i.get_name()])


func connect_signals() -> void:
	Events.connect('add_cash', self, 'add_cash')
	Events.connect('base_damage', self, 'on_base_damage')


func _process(_delta) -> void:
	if build_mode:
		update_tower_preview()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released('ui_cancel') and build_mode == true:
		cancel_build_mode()
	if event.is_action_released('ui_accept') and build_mode == true:
		verify_and_build()
		cancel_build_mode()


##
## Building Functions
##
func update_tower_preview() -> void:
	var mouse_position = get_global_mouse_position()
	var current_tile = $Map/TowerExclusion.world_to_map(mouse_position)
	var tile_position = $Map/TowerExclusion.map_to_world(current_tile)

	if $Map/TowerExclusion.get_cellv(current_tile) == -1:
		$UI.update_tower_preview(tile_position, GREEN)
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		$UI.update_tower_preview(tile_position, RED)
		build_valid = false


func initiate_build_mode(tower_type: String) -> void:
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + 'T1'
	build_mode = true
	$UI.set_tower_preview(build_type, get_global_mouse_position())


func cancel_build_mode() -> void:
	build_mode = false
	build_valid = false
	$UI/TowerPreview.free()


func verify_and_build() -> void:
	if build_valid:
		var new_tower = load('res://Scenes/Turrets/' + build_type + '.tscn').instance()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]['category']
		$Map/Turrets.add_child(new_tower, true)
		$Map/TowerExclusion.set_cellv(build_tile, 5)
		deduct_cash(new_tower.type)


func add_cash(type: String) -> void:
	var value = GameData.tank_data[type]['value']
	var current_cash = int(cash_node.text)
	current_cash += value
	cash_node.text = str(current_cash)
	Events.emit_signal('cash_changed')


func deduct_cash(type: String) -> void:
	var cost = GameData.tower_data[type]['cost']
	var current_cash = int(cash_node.text)
	current_cash -= cost
	cash_node.text = str(current_cash)
	Events.emit_signal('cash_changed')


func on_base_damage(damage: int) -> void:
	base_health -= damage
	if base_health <= 0:
		Events.emit_signal('game_finished')
	else:
		$UI.update_health_bar(base_health)
