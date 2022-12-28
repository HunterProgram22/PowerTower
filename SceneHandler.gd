# warning-ignore-all:return_value_discarded
"""Main control for the game."""
extends Node


const GAME_SCENE: String = 'res://Scenes/MainScenes/GameScene.tscn'
const MAIN_MENU: String = 'res://Scenes/UIScenes/MainMenu.tscn'
const MAP_MENU: String = 'res://Scenes/UIScenes/MapMenu.tscn'


func _ready() -> void:
	connect_signals()
	load_main_menu()


func connect_signals() -> void:
	Events.connect('new_game_pressed', self, 'load_map_menu')
	Events.connect('quit_pressed', self, 'quit_game')
	Events.connect('start_game_map', self, 'start_game')
	Events.connect('game_finished', self, 'unload_game')
	Events.connect('level_completed', self, 'return_to_map_menu')


func load_main_menu() -> void:
	var main_menu = load(MAIN_MENU).instance()
	add_child(main_menu)


func load_map_menu() -> void:
	"""Loads map menu from main menu."""
	$MainMenu.queue_free()
	var map_menu = load(MAP_MENU).instance()
	add_child(map_menu)


func return_to_map_menu(map_name: String) -> void:
	"""Loads map menu after a level is completed."""
	GameData.maps_completed.append(map_name)
	$GameScene.queue_free()
	var map_menu = load(MAP_MENU).instance()
	add_child(map_menu)


func start_game(map: String) -> void:
	$MapMenu.queue_free()
	var game_scene = load(GAME_SCENE).instance()
	game_scene.map_name = map
	add_child(game_scene)


func unload_game() -> void:
	$GameScene.queue_free()
	var main_menu = load(MAIN_MENU).instance()
	add_child(main_menu)


func quit_game() -> void:
	get_tree().quit()
