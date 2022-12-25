extends Node

signal new_game_pressed
signal quit_pressed


func _ready():
	connect_signals()


func connect_signals():
	get_node('M/VB/NewGame').connect('pressed', self, 'on_new_game_pressed')
	get_node('M/VB/Quit').connect('pressed', self, 'on_quit_pressed')


func on_new_game_pressed():
	emit_signal('new_game_pressed')


func on_quit_pressed():
	emit_signal('quit_pressed')
