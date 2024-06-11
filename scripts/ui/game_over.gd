extends Control

# Переход в главное меню
func _on_RestartButton_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
