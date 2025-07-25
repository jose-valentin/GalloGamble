extends Node

var player_balance: int = 100  # starting money

func add_money(amount: int):
	player_balance += amount

func subtract_money(amount: int):
	player_balance -= amount

var current_bet: int = 0
var bet_on: int = -1  # -1 = none, 0 = rooster A, 1 = rooster B

var wall_hits = {
	"A": 0,
	"B": 0
}
