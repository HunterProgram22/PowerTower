extends Control


onready var map_completed


func _ready():
	connect_signals()
	if map_completed != null:
		update_button_color(map_completed)


func connect_signals():
	get_node('M/VB/Quit').connect('pressed', self, 'on_quit_pressed')
	get_node('M/VB/Map1').connect('pressed', self, 'start_map', ['Map1'])
	get_node('M/VB/Map2').connect('pressed', self, 'start_map', ['Map2'])
	get_node('M/VB/Map3').connect('pressed', self, 'start_map', ['Map3'])


func update_button_color(map):
	get_node('M/VB/' + map + '/Label').set('custom_colors/font_color', Color('03f809'))
	print('button color changed')


func on_quit_pressed():
    Events.emit_signal('quit_pressed')


func start_map(map):
    Events.emit_signal('start_game_map', map)
