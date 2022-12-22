extends "res://Scenes/Enemies/BaseTank.gd"


func _ready():
	speed = GameData.tank_data["MasterTank"]["speed"]
	hp = GameData.tank_data["MasterTank"]["hp"]
	base_damage = GameData.tank_data["MasterTank"]["base_damage"]
	._ready()
