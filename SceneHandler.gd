extends Node

var game_scene = load('res://Scenes/MainScenes/GameScene.tscn').instance()
var main_menu = load('res://Scenes/UIScenes/MainMenu.tscn').instance()
var map_menu = load('res://Scenes/UIScenes/MapMenu.tscn').instance()



func _ready():
	load_main_menu()


func load_main_menu():
	add_child(main_menu)
	main_menu.connect('new_game_pressed', self, 'load_map_menu')
	main_menu.connect('quit_pressed', self, 'quit_game')


func load_map_menu():
	print('load map menu')
	$MainMenu.queue_free()
	add_child(map_menu)
	get_node('MapMenu/M/VB/Quit').connect('pressed', self, 'on_quit_pressed')
	get_node('MapMenu/M/VB/Map1').connect('pressed', self, 'start_map_1')
	get_node('MapMenu/M/VB/Map2').connect('pressed', self, 'start_map_2')
	get_node('MapMenu/M/VB/Map3').connect('pressed', self, 'start_map_3')


func quit_game():
	get_tree().quit()


func start_map_1():
	$MapMenu.queue_free()
	game_scene.map_node = 'Map1'
	start_game()


func start_map_2():
	$MapMenu.queue_free()
	game_scene.map_node = 'Map2'
	start_game()


func start_map_3():
	$MapMenu.queue_free()
	game_scene.map_node = 'Map3'
	start_game()


func start_game():
	game_scene.connect('game_finished', self, 'unload_game')
	game_scene.connect('level_completed', self, 'load_map_menu')
	add_child(game_scene)


func unload_game(result):
	get_node('GameScene').queue_free()
	var start_menu = load('res://Scenes/UIScenes/MainMenu.tscn').instance()
	add_child(start_menu)
