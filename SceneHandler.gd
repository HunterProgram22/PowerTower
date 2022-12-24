extends Node

var game_scene = load('res://Scenes/MainScenes/GameScene.tscn').instance()


func _ready():
	connect_scene_handler_signals()
	load_main_menu()


func load_main_menu():
	$MainMenu.visible = true
#	$MapMenu.visible = false


func load_map_menu():
	$MainMenu.visible = false
	$MapMenu.visible = true


func connect_scene_handler_signals():
	get_node('MainMenu/M/VB/NewGame').connect('pressed', self, 'on_new_game_pressed')
	get_node('MainMenu/M/VB/Quit').connect('pressed', self, 'on_quit_pressed')
	get_node('MapMenu/M/VB/Quit').connect('pressed', self, 'on_quit_pressed')
	get_node('MapMenu/M/VB/Map1').connect('pressed', self, 'start_map_1')
	get_node('MapMenu/M/VB/Map2').connect('pressed', self, 'start_map_2')
	get_node('MapMenu/M/VB/Map3').connect('pressed', self, 'start_map_3')


func on_new_game_pressed():
	load_map_menu()


func on_quit_pressed():
	get_tree().quit()


func start_map_1():
	$MainMenu.queue_free()
	$MapMenu.queue_free()
	game_scene.map_node = 'Map1'
	start_game()


func start_map_2():
	$MainMenu.queue_free()
	$MapMenu.queue_free()
	game_scene.map_node = 'Map2'
	start_game()


func start_map_3():
	$MainMenu.queue_free()
	$MapMenu.queue_free()
	game_scene.map_node = 'Map3'
	start_game()


func start_game():
	game_scene.connect('game_finished', self, 'unload_game')
	game_scene.connect('level_completed', self, 'load_map_menu')
	add_child(game_scene)


func unload_game(result):
	get_node('GameScene').queue_free()
	var main_menu = load('res://Scenes/UIScenes/MainMenu.tscn').instance()
	add_child(main_menu)
	load_main_menu()
