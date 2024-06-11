extends CharacterBody2D
class_name Player

# ЗАГРУЗКА СЦЕН:
@onready var InteractLabel = $Interaction/InteractLabel
@onready var Controle = $"../../UILayer/Control"
@onready var laser_scene = preload("res://scenes/shot.tscn")

# СИГНАЛЫ:
signal laser_shot(laser_scene, location, target, damage)
signal HP_change(HP)

# ПЕРЕМЕННЫЕ:
const accel = 1200
const friction = 1400
var movement_vector = Vector2.ZERO
var all_interaction = []
var all_target_attack = []
var target = null
var shoot_cd = false
var rate_of_fire = 0.25
var damage = 10
var HP = 100

# ФУНКЦИИ:
func _ready():
	pass

func _process(_delta):
	if all_target_attack:
		all_target_attack.sort_custom(_sort_distance)
		target = all_target_attack[0]
		if not shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false
	if HP <= 0:
		queue_free()

func _physics_process(_delta):
	player_movement(_delta)
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	move_and_slide()
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func get_input():
	movement_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	movement_vector.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return movement_vector.normalized()

func player_movement(delta):
	movement_vector = get_input()
	if movement_vector == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (movement_vector * accel * delta)
		velocity = velocity.limit_length(Global.speed_player)

func _on_interaction_area_area_entered(area):
	all_interaction.insert(0, area)
	update_interaction()

func _on_interaction_area_area_exited(area):
	all_interaction.erase(area)
	update_interaction()

func update_interaction():
	if all_interaction:
		InteractLabel.text = 'E'
	else:
		InteractLabel.text = ''

func execute_interaction():
	if all_interaction:
		if all_interaction[0].is_in_group("portal"):
			if Controle:
				Controle.visible = not Controle.visible

func shoot():
	laser_shot.emit(laser_scene, global_position, target, damage)

func _on_attack_radius_area_entered(area):
	all_target_attack.insert(0, area)

func _on_attack_radius_area_exited(area):
	all_target_attack.erase(area)

func _sort_distance(area1, area2):
	var area1_to_player = global_position.distance_to(area1.global_position)
	var area2_to_player = global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func hit(damage_mobs):
	HP -= damage_mobs
	HP_change.emit(HP)
