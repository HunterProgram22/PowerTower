# warning-ignore-all:return_value_discarded
extends CanvasLayer


var current_wave_value : int = 1
var money : int = 150

onready var current_money : Node = get_node('HUD/InfoBar/H/Money')
onready var hp_bar : Node = get_node('HUD/InfoBar/H/HP')
onready var hp_bar_tween : Node = get_node('HUD/InfoBar/H/HP/Tween')
onready var wave_value : Node = get_node('HUD/InfoBar/H/Wave')
onready var gun_button : Node = get_node('HUD/BuildBar/Gun')
onready var missile_button : Node = get_node('HUD/BuildBar/Missile')


func _ready() -> void:
	set_money()
	set_buttons()
	connect_signals()


func connect_signals() -> void:
	Events.connect('cash_changed', self, 'set_buttons')


func set_buttons() -> void:
	if int(current_money.text) >= 50:
		gun_button.set_disabled(false)
	else:
		gun_button.set_disabled(true)
	if int(current_money.text) >= 150:
		missile_button.set_disabled(false)
	else:
		missile_button.set_disabled(true)


func set_money() -> void:
	current_money.text = str(money)


func set_tower_preview(tower_type: String, mouse_position: Vector2) -> void:
	var drag_tower = create_drag_tower(tower_type)
	var tower_range = create_tower_range(tower_type)

	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(tower_range, true)
	control.rect_position = mouse_position
	control.set_name('TowerPreview')
	add_child(control, true)
	move_child(get_node('TowerPreview'), 0)


func update_tower_preview(new_position: Vector2, color: String) -> void:
	get_node('TowerPreview').rect_position = new_position
	if get_node('TowerPreview/DragTower').modulate != Color(color):
		get_node('TowerPreview/DragTower').modulate = Color(color)
		get_node('TowerPreview/Sprite').modulate = Color(color)


func create_drag_tower(tower_type: String) -> Node2D:
	"""Creates image of tower to drag on map for building."""
	var tower = load('res://Scenes/Turrets/' + tower_type + '.tscn').instance()
	tower.set_name('DragTower')
	tower.modulate = Color('ad54ff3c')
	return tower


func create_tower_range(tower_type: String) -> Sprite:
	"""Creates an image that shows the towers range."""
	var range_texture = Sprite.new()
	range_texture.position = Vector2(32, 32)
	var scaling = GameData.tower_data[tower_type]['range'] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	range_texture.texture = load('res://Assets/UI/range_overlay.png')
	range_texture.modulate = Color('ad54ff3c')
	return range_texture


##
## Game Control Functions
##
func _on_PausePlay_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
	elif get_parent().current_wave == 0:
		get_parent().start_next_wave()
	else:
		get_tree().paused = true


func _on_SpeedUp_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)


func update_health_bar(base_health):
	hp_bar_tween.interpolate_property(hp_bar, 'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	if base_health >= 60:
		hp_bar.set_tint_progress('0af90a')  # Green
	elif base_health <= 60 and base_health >= 25:
		hp_bar.set_tint_progress('e1be32')  # Orange
	else: 
		hp_bar.set_tint_progress('e11e1e')  # Red


func update_wave_ui():
	current_wave_value += 1
	wave_value.text = str(current_wave_value)
