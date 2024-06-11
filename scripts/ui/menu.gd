extends Control

# Функция для кнопки старта
func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://scenes/locations/village1.tscn")

# Функция для кнопки выхода
func _on_QuitButton_pressed():
	get_tree().quit()
