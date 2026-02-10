extends Node
class_name SlotMachinePool

@export var symbol_pool: Dictionary[SymbolData, int] = {}

@onready var symbol: SlotMachinePoolSymbol = $Symbol
@onready var token: SlotMachinePoolToken = $Token


func init():
	symbol.pool = symbol_pool
	symbol.init()
