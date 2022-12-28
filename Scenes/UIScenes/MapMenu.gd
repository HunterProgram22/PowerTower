# warning-ignore-all:return_value_discarded
extends Control


onready var map_completed
onready var map1_button = get_node('M/VB/Map1')
onready var map2_button = get_node('M/VB/Map2')
onready var map3_button = get_node('M/VB/Map3')
onready var quit_button = get_node('M/VB/Quit')


func _ready() -> void:
	connect_signals()
	update_button_color()


func connect_signals() -> void:
	quit_button.connect('pressed', self, 'on_quit_pressed')
	map1_button.connect('pressed', self, 'start_map', ['Map1'])
	map2_button.connect('pressed', self, 'start_map', ['Map2'])
	map3_button.connect('pressed', self, 'start_map', ['Map3'])


func update_button_color() -> void:
	for map in GameData.maps_completed:
		get_node('M/VB/' + map + '/Label').set('custom_colors/font_color', Color('03f809'))


func on_quit_pressed() -> void:
	Events.emit_signal('quit_pressed')


func start_map(map: String) -> void:
	Events.emit_signal('start_game_map', map)
