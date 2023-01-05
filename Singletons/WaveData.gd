extends Node

const BT: String = 'BlueTank'
const RT: String = 'RedTank'
const MT: String = 'MasterTank'

const F: float = 0.5
const M: float = 1.0
const S: float = 2.0


const FIVE_BLUE_M: Dictionary = {
	'wave_speed': M,
	'wave_type': BT,
	'wave_count': 5,
}

const THREE_RED_F: Dictionary = {
	'wave_speed': F,
	'wave_type': RT,
	'wave_count': 3,
}

const TWO_MASTER_S: Dictionary = {
	'wave_speed': S,
	'wave_type': MT,
	'wave_count': 2,
}

var wave_data = {
	'Map1':
	[
		FIVE_BLUE_M,
		THREE_RED_F,
		TWO_MASTER_S,
	],
	'Map2':
	[
		FIVE_BLUE_M,
		THREE_RED_F,
		TWO_MASTER_S,
		FIVE_BLUE_M,
	],
	'Map3':
	[
		FIVE_BLUE_M,
		THREE_RED_F,
		TWO_MASTER_S,
		TWO_MASTER_S,
	],
}
