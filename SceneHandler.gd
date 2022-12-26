extends Node



func _ready() -> void:
	connect_signals()
	load_main_menu()


func connect_signals() -> void:
	Events.connect('new_game_pressed', self, 'load_map_menu')
	Events.connect('quit_pressed', self, 'quit_game')
	Events.connect('start_game_map', self, 'start_game')


func load_main_menu() -> void:
	var main_menu = load('res://Scenes/UIScenes/MainMenu.tscn').instance()
	add_child(main_menu)


func load_map_menu() -> void:
	$MainMenu.queue_free()
	var map_menu = load('res://Scenes/UIScenes/MapMenu.tscn').instance()
	add_child(map_menu)


func return_to_map_menu(map: str) -> void:
	$GameScene.queue_free()
	var map_menu = load('res://Scenes/UIScenes/MapMenu.tscn').instance()
	map_menu.map_completed = map
	add_child(map_menu)


func quit_game() -> void:
	get_tree().quit()


func start_game(map: str) -> void:
	$MapMenu.queue_free()
	var game_scene = load('res://Scenes/MainScenes/GameScene.tscn').instance()
	game_scene.map_node = map
	game_scene.connect('game_finished', self, 'unload_game')
	game_scene.connect('level_completed', self, 'return_to_map_menu', [map])
	add_child(game_scene)


func unload_game(result) -> void:
	$GameScene.queue_free()
	var main_menu = load('res://Scenes/UIScenes/MainMenu.tscn').instance()
	add_child(main_menu)
