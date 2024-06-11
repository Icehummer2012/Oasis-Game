extends Control

# Узлы для отображения очков и здоровья
@onready var score_label := $VBoxContainer/ScoreLabel
@onready var hp_label := $VBoxContainer/HPLabel
@onready var time_label := $VBoxContainer/TimeLabel

# Глобальные переменные
var score = 0
var hp = 100
var time = 0  # Объявите переменную time

# Обновление очков
func set_score(value):
	score = value
	if score_label != null:
		score_label.text = str(score)
	else:
		print("ScoreLabel is null")

# Обновление здоровья
func set_hp(value):
	hp = value
	if hp_label != null:
		hp_label.text = str(hp)
	else:
		print("HPLabel is null")

# Обновление времени
func set_time(value):
	time = value
	if time_label != null:
		time_label.text = str(time)
	else:
		print("TimeLabel is null")

# Пример использования в другом скрипте
func _ready():
	set_score(Global.score)
	set_hp(Global.hp)
	set_time(time)  # Установите начальное значение времени
