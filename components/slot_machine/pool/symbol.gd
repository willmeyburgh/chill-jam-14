extends Node
class_name SlotMachinePoolSymbol

var pool: Dictionary[SymbolData, int] = {}
var weights: Array[int] = []
var indexes: Array[SymbolData] = []

func init():
	for key in pool.keys():
		weights.append(pool[key])
		indexes.append(key)

func next() -> Symbol:
	var data: SymbolData = indexes[Global.rng.rand_weighted(weights)]
	return SymbolFactory.create(data)
