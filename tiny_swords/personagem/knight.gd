extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
@onready var attack_area_collision: CollisionShape2D = get_node("AtackArea/Collision")
@onready var texture: Sprite2D = get_node("Texture")
@onready var AnimationPlayserAux: AnimationPlayer = get_node("AnimationPlayerAux")

@export var move_speed: float = 256.0
@export var damage: int = 1
@export var health: int = 10

var pode_atarcer: bool = true
var pode_morrer: bool = false 

func _physics_process(_delta: float) -> void:
	if (pode_atarcer == false or pode_morrer == true):
		return
	move()
	animate()
	atack_handle()
	
func move() -> void:	
	var direction: Vector2 = get_direction()
	velocity = direction * move_speed
	move_and_slide()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("move_left","move_right"),
		Input.get_axis("move_up","move_down")
	).normalized()

func animate() -> void:
	
	if velocity.x >0:
		texture.flip_h = false
		attack_area_collision.position.x = 58
		
	if velocity.x <0:
		texture.flip_h = true
		attack_area_collision.position.x = -58
	
	if velocity != Vector2(0,0):
		animation.play("correndo")
		return
	animation.play("parado")

func atack_handle() -> void:
	if Input.is_action_just_pressed("atack") and pode_atarcer:
		pode_atarcer = false
		animation.play("atack")


func _on_animation_player_animation_finished(anim_name):
	match  anim_name:
		"atack":
			pode_atarcer = true
		"morte":
			get_tree().reload_current_scene()

func _on_atack_area_body_entered(body):
	print("Corpo detectado: ", body.name)
	body.update_health(damage)

func update_health(value: int) -> void:
	health -= value
	if health <= 0:
		pode_morrer = true
		animation.play("morte")
		attack_area_collision.set_deferred("disable",true)
		return
		
	AnimationPlayserAux.play("dano")
