class_name Projectile extends Node2D

enum ACTION_MODES {
	STRAIGHT,
	SEEKING
}

const PITCH_VARIATION : Vector2 = Vector2(0.7,1.3)

@onready var lifetime_timer : Timer = $LifetimeTimer

@export_group('Projectile Properties')
@export var action_mode : ACTION_MODES = 0 ## Affects processes and movement
@export var base_lifetime : float = 3
@export var base_speed : int = 600
@export var base_piercing : int = 1
@export var base_damage : int = 5
@export var base_seeking_weight : float = 0.5

@export_group('Cosmetic Properties')
@export var sfx_when_launched : Array[String]
@export var sfx_when_hit : Array[String]
@export var sfx_when_broken : Array[String]

var target : Node2D
var active : bool = true
var speed : int
var lifetime : float
var stored_direction : Vector2
var init_pos : Vector2

func _ready() -> void:
	speed = base_speed
	lifetime = base_lifetime
	_activate()

func _activate() -> void:
	await lifetime_timer.timeout # TODO: Personalized timer / distance delta
	_break()

func _deactivate() -> void:
	active = false
	set_visible(false)

func _physics_process(delta) -> void:
	# var distance_delta = global_position.distance_squared_to(init_pos)
	# print(distance_delta)
	match action_mode:
		0: #| 'STRAIGHT'
			global_position += Vector2(speed * delta, 0).rotated(rotation)
		1: #| 'SEEKING'
			if is_instance_valid(target): 
				stored_direction = global_position.direction_to(target.global_position)
				var angle = transform.x.angle_to(stored_direction)
				rotate(sign(angle) * min(delta * TAU * 2, abs(angle)))
			else:
				action_mode = 0; return
			global_position += (stored_direction * speed * delta)
		_: push_error('INVALID PROJECTILE_TYPE')

func _break() -> void:
	#match projectile_mode:
	#	pass
	_deactivate()
	set_physics_process(false)
	queue_free()
