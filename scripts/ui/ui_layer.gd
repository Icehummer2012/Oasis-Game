extends CanvasLayer

@onready var score = $HUD/Score:
	#каждый раз когда меняется переменная происходит это
	set(value):
		score.text = "ОЧКИ:" + str(value)
