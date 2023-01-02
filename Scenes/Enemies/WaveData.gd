extends Node

const BT: String = 'BlueTank'
const RT: String = 'RedTank'
const MT: String = 'MasterTank'

const F: float = 0.5
const M: float = 1.0
const S: float = 2.0

const FIVE_BLUE_M: Array = [[BT, M], [BT, M], [BT, M], [BT, M], [BT, M]]
const THREE_RED_F: Array = [[RT, F], [RT, F], [RT, F]]
const TWO_MASTER_S: Array = [[MT, S], [MT, S]]

var wave_data = {
	'Map1':
	[
		TWO_MASTER_S,
		THREE_RED_F,
		[[BT, M], [BT, S], [BT, M], [BT, M],],
		FIVE_BLUE_M,
		[[BT, M], [RT, S], [RT, M]],
		[[BT, M], [RT, M], [RT, M], [MT, M],],
	],
	'Map2':
	[
		[[MT, M], [BT, S], [BT, M], [BT, M],],
		[[RT, M], [RT, S], [RT, M],],
		[[MT, M], [RT, M], [MT, M], [MT, M],],
	],
	'Map3':
	[
		[[MT, M], [BT, S], [BT, M], [BT, M],],
		[[MT, M], [BT, S], [RT, M],],
		[[MT, M], [RT, M], [MT, M], [MT, M],],
	],
}
