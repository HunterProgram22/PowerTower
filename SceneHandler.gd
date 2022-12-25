extends Node



func _ready():
	load_main_menu()


func load_main_menu():
	var main_menu = load('res://Scenes/UIScenes/MainMenu.tscn').instance()
	add_child(main_menu)
	connect_main_menu_recievers(main_menu)


func connect_main_menu_recievers(main_menu):
	main_menu.connect('new_game_pressed', self, 'load_map_menu')
	main_menu.connect('quit_pressed', self, 'quit_game')


func load_map_menu():
	$MainMenu.queue_free()
	var map_menu = load('res://Scenes/UIScenes/MapMenu.tscn').instance()
	add_child(map_menu)
	map_menu.connect('quit_pressed', self, 'quit_game')
	map_menu.connect('start_game_map', self, 'start_game')


func return_to_map_menu(map):
	$GameScene.queue_free()
	var map_menu = load('res://Scenes/UIScenes/MapMenu.tscn').instance()
	map_menu.map_completed = map
	add_child(map_menu)
	map_menu.connect('quit_pressed', self, 'quit_game')
	map_menu.connect('start_game_map', self, 'start_game')


func quit_game():
	get_tree().quit()


func start_game(map):
	$MapMenu.queue_free()
	var game_scene = load('res://Scenes/MainScenes/GameScene.tscn').instance()
	game_scene.map_node = map
	game_scene.connect('game_finished', self, 'unload_game')
	game_scene.connect('level_completed', self, 'return_to_map_menu', [map])
	add_child(game_scene)


func unload_game(result):
	$GameScene.queue_free()
	var main_menu = load('res://Scenes/UIScenes/MainMenu.tscn').instance()
	add_child(main_menu)
	connect_main_menu_recievers(main_menu)
