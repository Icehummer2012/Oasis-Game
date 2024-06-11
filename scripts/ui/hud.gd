extends Control

# Узлы для отображения очков и здоровья
@onready var score_label := $VBoxContainer/ScoreLabel
@onready var hp_label := $VBoxContainer/HPLabel

# Глобальные переменные
var score = 0
var hp = 100

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

# Пример использования в другом скрипте
func _ready():
	set_score(Global.score)
	set_hp(Global.hp)
