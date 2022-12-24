extends Control

signal quit_pressed
signal start_game_map(map)


func _ready():
    connect_signals()


func connect_signals():
	get_node('M/VB/Quit').connect('pressed', self, 'on_quit_pressed')
	get_node('M/VB/Map1').connect('pressed', self, 'start_map', ['Map1'])
	get_node('M/VB/Map2').connect('pressed', self, 'start_map', ['Map2'])
	get_node('M/VB/Map3').connect('pressed', self, 'start_map', ['Map3'])


func on_quit_pressed():
    emit_signal('quit_pressed')


func start_map(map):
    emit_signal('start_game_map', map)