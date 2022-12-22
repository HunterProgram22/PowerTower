extends "res://Scenes/Enemies/BaseTank.gd"


func _ready():
	speed = GameData.tank_data["BlueTank"]["speed"]
	hp = GameData.tank_data["BlueTank"]["hp"]
	base_damage = GameData.tank_data["BlueTank"]["base_damage"]
	._ready()
