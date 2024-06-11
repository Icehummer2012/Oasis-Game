extends Area2D

# Скорость снаряда
@export var speed = 500
# Урон пули
@export var damage = 1
# Выбранная цель
var target: Node2D = null

# Основной процесс
func _physics_process(delta: float) -> void:
	if target != null:
		var direction: Vector2 = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
	else:
		queue_free()

# Удаляем снаряд при выходе из поля видимости
func _on_VisibleOnScreenEnabler2D_screen_exited() -> void:
	queue_free()

# Действие при столкновении с объектом
func _on_body_entered(body: Node) -> void:
	if body is Mobs:
		body.hit(damage)
		queue_free()

# Подключение сигналов
func _ready() -> void:
	if not $VisibleOnScreenEnabler2D.is_connected("screen_exited", Callable(self, "_on_VisibleOnScreenEnabler2D_screen_exited")):
		$VisibleOnScreenEnabler2D.connect("screen_exited", Callable(self, "_on_VisibleOnScreenEnabler2D_screen_exited"))
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
