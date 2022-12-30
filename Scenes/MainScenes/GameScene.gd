# warning-ignore-all:return_value_discarded
extends Node2D


var map: Node2D
var map_name: String
var base_health: int = 100

onready var cash_node: Label = $UI/HUD/InfoBar/H/Money



func _ready() -> void:
	connect_signals()
	map = load('res://Scenes/Maps/' + map_name + '.tscn').instance()
	add_child(map)


func connect_signals() -> void:
	Events.connect('add_cash', self, 'add_cash')
	Events.connect('base_damage', self, 'on_base_damage')
	Events.connect('deduct_cash', self, 'deduct_cash')


func _process(_delta) -> void:
	if $TurretManager.build_mode:
		$TurretManager.update_tower_preview()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released('ui_cancel') and $TurretManager.build_mode == true:
		$TurretManager.cancel_build_mode()
	if event.is_action_released('ui_accept') and $TurretManager.build_mode == true:
		$TurretManager.verify_and_build()
		$TurretManager.cancel_build_mode()


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
