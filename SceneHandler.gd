extends Node



func _ready():
	load_main_menu()


func load_main_menu():
	get_node("MainMenu/M/VB/NewGame").connect("pressed", self, "on_new_game_pressed")
	get_node("MainMenu/M/VB/Quit").connect("pressed", self, "on_quit_pressed")	


func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	game_scene.connect("game_finished", self, "unload_game")
	game_scene.connect("level_completed", self, "load_map_menu")
	add_child(game_scene)


func on_quit_pressed():
	get_tree().quit()


func load_map_menu():
	get_node("GameScene").queue_free()
	var map_menu = load("res://Scenes/UIScenes/MapMenu.tscn").instance()
	add_child(map_menu)


func unload_game(result):
	get_node("GameScene").queue_free()
	var main_menu = load("res://Scenes/UIScenes/MainMenu.tscn").instance()
	add_child(main_menu)
	load_main_menu()
