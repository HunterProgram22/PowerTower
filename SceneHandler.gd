extends Node


const GAME_SCENE : String = 'res://Scenes/MainScenes/GameScene.tscn'
const MAIN_MENU : String = 'res://Scenes/UIScenes/MainMenu.tscn'
const MAP_MENU : String = 'res://Scenes/UIScenes/MapMenu.tscn'


func _ready() -> void:
	connect_signals()
	load_main_menu()


func connect_signals() -> void:
	Events.connect('new_game_pressed', self, 'load_map_menu')
	Events.connect('quit_pressed', self, 'quit_game')
	Events.connect('start_game_map', self, 'start_game')


func load_main_menu() -> void:
	var main_menu = load(MAIN_MENU).instance()
	add_child(main_menu)


func load_map_menu() -> void:
	$MainMenu.queue_free()
	var map_menu = load(MAP_MENU).instance()
	add_child(map_menu)


func return_to_map_menu(map: String) -> void:
	$GameScene.queue_free()
	var map_menu = load(MAP_MENU).instance()
	map_menu.map_completed = map
	add_child(map_menu)


func quit_game() -> void:
	get_tree().quit()


func start_game(map: String) -> void:
	$MapMenu.queue_free()
	var game_scene = load(GAME_SCENE).instance()
	game_scene.map_node = map
	game_scene.connect('game_finished', self, 'unload_game')
	game_scene.connect('level_completed', self, 'return_to_map_menu', [map])
	add_child(game_scene)


func unload_game(result) -> void:
	$GameScene.queue_free()
	var main_menu = load(MAIN_MENU).instance()
	add_child(main_menu)
