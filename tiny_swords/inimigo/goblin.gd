extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
@onready var AnimationPlayserAux: AnimationPlayer = get_node("AnimationPlayer2")

@export var move_speed: float = 192.0
@export var distance_threshold: float = 60.0
@export var damage: int = 1
@export var health: int = 3

var player_ref: CharacterBody2D = null
var pode_atarcer: bool = true
var pode_morrer: bool = false 

func _physics_process(_delta: float) ->void:
	if pode_morrer == true:
		return
		
	if player_ref == null:
		velocity =  Vector2(0,0)
		animate()
		return
	
	var direction: Vector2 = global_position.direction_to(player_ref.global_position)
	var distancia: float = global_position.distance_to(player_ref.global_position)
	if distancia < distance_threshold:
		animation.play("ataque")
		return
	velocity = direction * move_speed
	move_and_slide()
	animate()

func animate() -> void:
	if velocity != Vector2(0,0):
		animation.play("correr")
#
func update_health(value: int) -> void:
	if pode_morrer:
		return
	
	health -= value
	print(health)
	if health <= 0:
		pode_morrer = true
		animation.play("morte")

		return
		
	AnimationPlayserAux.play("dano")

func _on_area_2d_detection_body_entered(body):
	player_ref = body


func _on_area_2d_detection_body_exited(_body):
	player_ref = null


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "morte":
		queue_free()
