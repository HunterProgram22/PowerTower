# warning-ignore-all:return_value_discarded
extends Node


onready var new_game_button = get_node('M/VB/NewGame')
onready var quit_button = get_node('M/VB/Quit')


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	new_game_button.connect('pressed', self, 'on_new_game_pressed')
	quit_button.connect('pressed', self, 'on_quit_pressed')


func on_new_game_pressed() -> void:
	Events.emit_signal('new_game_pressed')


func on_quit_pressed() -> void:
	Events.emit_signal('quit_pressed')
