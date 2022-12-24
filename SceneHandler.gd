extends Node

var game_scene = load('res://Scenes/MainScenes/GameScene.tscn').instance()
var main_menu = load('res://Scenes/UIScenes/MainMenu.tscn').instance()
var map_menu = load('res://Scenes/UIScenes/MapMenu.tscn').instance()



func _ready():
	load_main_menu()


func load_main_menu():
	add_child(main_menu)
	get_node('MainMenu/M/VB/NewGame').connect('pressed', self, 'on_new_game_pressed')
	get_node('MainMenu/M/VB/Quit').connect('pressed', self, 'on_quit_pressed')


func load_map_menu():
    $MainMenu.queue_free()
    add_child(map_menu)
    get_node('MapMenu/M/VB/Quit').connect('pressed', self, 'on_quit_pressed')
    get_node('MapMenu/M/VB/Map1').connect('pressed', self, 'start_map_1')
    get_node('MapMenu/M/VB/Map2').connect('pressed', self, 'start_map_2')
    get_node('MapMenu/M/VB/Map3').connect('pressed', self, 'start_map_3')


func on_new_game_pressed():
	load_map_menu()


func on_quit_pressed():
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
