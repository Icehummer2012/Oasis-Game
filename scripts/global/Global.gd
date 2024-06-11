extends Node
class_name GlobalManager

# Глобальные переменные
var stage_game = 1
var location = "village"
var points = 0
var score = 0
var hp = 100  # Добавьте эту строку, если ее нет

# Глобальные функции
func reset_game():
	stage_game = 1
	location = "village"
	points = 0
	score = 0
	hp = 100  # Сброс здоровья при перезапуске игры
