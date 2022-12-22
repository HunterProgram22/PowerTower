extends "res://Scenes/Enemies/BaseTank.gd"

func _ready():
	speed = GameData.tank_data["RedTank"]["speed"]
	hp = GameData.tank_data["RedTank"]["hp"]
	base_damage = GameData.tank_data["RedTank"]["base_damage"]
	._ready()
