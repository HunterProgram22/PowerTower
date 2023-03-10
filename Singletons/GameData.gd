extends Node


var maps_completed = []


var tower_data = {
	'GunT1': {
		'damage': 20,
		'rof': 1.0,
		'range': 250,
		'cost': 50,
		'category': 'Projectile',
	},
	'GunT2': {
		'damage': 40,
		'rof': 1.0,
		'range': 300,
		'cost': 200,
		'category': 'Projectile',
	},
	'MissileT1': {
		'damage': 100,
		'rof': 3.0,
		'range': 550,
		'cost': 150,
		'category': 'Missile',
	},
}


var tank_data = {
	'BlueTank': {
		'hp': 50,
		'speed': 100,
		'base_damage': 20,
		'value': 25,
	},
	'RedTank': {
		'hp': 75,
		'speed': 150,
		'base_damage': 50,
		'value': 30,
	},
	'MasterTank': {
		'hp': 500,
		'speed': 50,
		'base_damage': 75,
		'value': 100,
	},
}
